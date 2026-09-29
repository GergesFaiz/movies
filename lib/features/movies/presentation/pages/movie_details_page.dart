import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/features/movies/presentation/bloc/movie_details_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/cast_item.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_snack_par.dart';
import '../../../../core/widgets/details_container.dart';
import '../../domain/entities/movie_entity.dart';
import '../widgets/movie_card.dart';

class MovieDetailsPage extends StatefulWidget {
  final MovieEntity movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    final movieId = widget.movie.id ?? 0;
    context.read<MovieDetailsBloc>()
      ..add(LoadMovieDetailsEvent(movieId))
      ..add(WatchWatchlistStatusEvent(movieId))
      ..add(AddToHistoryEvent(widget.movie));
  }

  /// The fully loaded movie when available, otherwise the one we were opened
  /// with (which may only have id, title, rating and poster).
  MovieEntity _currentMovie(MovieDetailsState state) =>
      state.details?.movie ?? widget.movie;

  Future<void> _openTrailer(MovieEntity movie) async {
    final local = AppLocalizations.of(context)!;
    final trailerUrl = movie.trailerUrl;
    if (trailerUrl == null) {
      showMyMessage(context, local.trailerUnavailable);
      return;
    }

    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(trailerUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }
    if (!opened && mounted) showMyMessage(context, local.couldNotOpenLink);
  }

  void _onStateChanged(BuildContext context, MovieDetailsState state) {
    final local = AppLocalizations.of(context)!;
    final error = state.watchlistError;
    if (error != null) {
      showMyMessage(context, error);
      return;
    }
    switch (state.watchlistAction) {
      case WatchlistAction.added:
        showMyMessage(context, local.addedToWatchList, isError: false);
      case WatchlistAction.removed:
        showMyMessage(context, local.removedFromWatchList, isError: false);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      body: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
        listenWhen: (previous, current) =>
            previous.watchlistAction != current.watchlistAction ||
            previous.watchlistError != current.watchlistError,
        listener: _onStateChanged,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                _buildTitleSection(context, state),
                SizedBox(height: 15.h),
                switch (state.status) {
                  MovieDetailsStatus.loaded => _buildMainDetails(
                    context,
                    state,
                  ),
                  MovieDetailsStatus.loading => Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: const CircularProgressIndicator(
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                  MovieDetailsStatus.failure => Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.h),
                      child: Column(
                        children: [
                          Text(
                            state.errorMessage ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.read<MovieDetailsBloc>().add(
                                  LoadMovieDetailsEvent(widget.movie.id ?? 0),
                                ),
                            child: Text(
                              AppLocalizations.of(context)!.tryAgain,
                              style: AppStyles.medium15Amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                },
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MovieDetailsState state) {
    final movie = _currentMovie(state);

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: movie.headerImage,
          height: 0.60.sh,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) =>
              Container(height: 0.60.sh, color: Colors.grey[900]),
        ),
        Container(
          height: 0.60.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.gray],
            ),
          ),
        ),
        Positioned.fill(
          top: 0.2.sh,
          child: Center(
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _openTrailer(movie),
              child: Image.asset(AppAssets.playButton),
            ),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                tooltip: state.isInWatchlist
                    ? AppLocalizations.of(context)!.removeFromWatchList
                    : AppLocalizations.of(context)!.addToWatchList,
                icon: Icon(
                  Icons.bookmark_rounded,
                  color: state.isInWatchlist ? Colors.amber : AppColors.white,
                ),
                onPressed: state.isTogglingWatchlist
                    ? null
                    : () => context.read<MovieDetailsBloc>().add(
                        ToggleWatchlistEvent(movie),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, MovieDetailsState state) {
    final loc = AppLocalizations.of(context)!;
    final movie = _currentMovie(state);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.h),
          Text(
            movie.title ?? '',
            textAlign: TextAlign.center,
            style: AppStyles.bold22White,
          ),
          if (movie.year != null) ...[
            SizedBox(height: 6.h),
            Text(
              movie.year.toString(),
              textAlign: TextAlign.center,
              style: AppStyles.medium14Gray,
            ),
          ],
          SizedBox(height: 10.h),
          CustomElevatedButton(
            label: loc.watch,
            backgroundColor: AppColors.red,
            textStyle: AppStyles.bold20White,
            onPressed: () => _openTrailer(movie),
          ),
        ],
      ),
    );
  }

  Widget _buildMainDetails(BuildContext context, MovieDetailsState state) {
    final loc = AppLocalizations.of(context)!;
    final details = state.details!;
    final description = details.movie.description;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DetailsContainer(text: details.likeCount, icon: Icons.favorite),
              DetailsContainer(
                text: details.runtime.toString(),
                icon: Icons.access_time_filled,
              ),
              DetailsContainer(
                text: details.rating.toString(),
                icon: Icons.star,
              ),
            ],
          ),

          // Screenshots
          if (details.screenshots.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.screenshots, style: AppStyles.bold22White),
            SizedBox(height: 12.h),
            ...details.screenshots.map((url) => _buildScreenshotItem(url)),
          ],

          // Suggestions
          if (details.suggestions.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.similar, style: AppStyles.bold22White),
            SizedBox(height: 10.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.suggestions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (context, index) {
                final movie = details.suggestions[index];
                return MovieCard(
                  imageUrl: movie.coverImage,
                  rating: movie.rating?.toString() ?? '0',
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.movieDetails,
                    arguments: movie,
                  ),
                );
              },
            ),
          ],

          // Summary
          SizedBox(height: 20.h),
          Text(loc.summary, style: AppStyles.bold22White),
          SizedBox(height: 8.h),
          Text(
            description.isEmpty ? loc.noDescription : description,
            style: AppStyles.regular16white,
          ),

          // Cast
          if (details.cast.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.cast, style: AppStyles.bold22White),
            SizedBox(height: 8.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: details.cast.length,
              itemBuilder: (context, index) {
                final actor = details.cast[index];
                return CastItem(
                  imageUrl: actor.imageUrl,
                  actorName: actor.name,
                  characterName: actor.characterName,
                );
              },
            ),
          ],

          // Genres
          if (details.genres.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(loc.genres, style: AppStyles.bold22White),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: details.genres
                  .map(
                    (genre) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        genre,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildScreenshotItem(String url) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 0.25.sh,
          errorWidget: (context, url, error) => Container(
            height: 150.h,
            color: Colors.grey[900],
            child: const Center(child: Icon(Icons.error, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
