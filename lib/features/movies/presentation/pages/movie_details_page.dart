import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/features/movies/presentation/bloc/movie_details_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/cast_item.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
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
    context.read<MovieDetailsBloc>().add(
      LoadMovieDetailsEvent(widget.movie.id ?? 0),
    );
    context.read<MovieDetailsBloc>().add(AddToHistoryEvent(widget.movie));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                if (state is MovieDetailsLoaded) ...[
                  _buildTitleSection(context, state),
                  SizedBox(height: 15.h),
                  _buildMainDetails(context, state),
                ] else if (state is MovieDetailsLoading ||
                    state is MovieDetailsInitial) ...[
                  _buildTitlePlaceholder(),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.h),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ] else if (state is MovieDetailsError) ...[
                  _buildTitlePlaceholder(),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.h),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MovieDetailsState state) {
    // نحاول نجيب الـ background image من الـ state لو موجودة
    // وإلا نعمل placeholder
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.movie.backgroundImage ?? widget.movie.coverImage,
          height: 0.60.sh,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) =>
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
              onTap: () {},
              child: Image.asset('assets/images/Group 21.png'),
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
              // Watchlist button with stream
              StreamBuilder<bool>(
                stream: context.read<MovieDetailsBloc>().isMovieInWatchlist(
                  widget.movie.id ?? 0,
                ),
                builder: (context, snapshot) {
                  final isSaved = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      Icons.bookmark_rounded,
                      color: isSaved ? Colors.amber : AppColors.white,
                    ),
                    onPressed: () => context.read<MovieDetailsBloc>().add(
                      ToggleWatchlistEvent(widget.movie),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, MovieDetailsLoaded state) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.h),
          Text(
            widget.movie.title ?? 'Movie',
            textAlign: TextAlign.center,
            style: AppStyles.bold22White,
          ),
          SizedBox(height: 10.h),
          CustomElevatedButton(
            label: loc.watch,
            backgroundColor: AppColors.red,
            textStyle: AppStyles.bold20White,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trailer playback is coming soon.')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitlePlaceholder() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.h),
          Text(
            widget.movie.title ?? 'Movie',
            style: AppStyles.bold18White,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMainDetails(BuildContext context, MovieDetailsLoaded state) {
    final loc = AppLocalizations.of(context)!;
    final details = state.details;

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
            Text('Screenshots', style: AppStyles.bold22White),
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
                    '/movie-details',
                    arguments: movie,
                  ),
                );
              },
            ),
          ],

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
                  imageUrl: actor['url_small_image'] ?? '',
                  actorName: actor['name'] ?? '',
                  characterName: actor['character_name'] ?? '',
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
