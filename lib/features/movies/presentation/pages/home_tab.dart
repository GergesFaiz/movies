import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movies/main.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/main_error_widget.dart';
import '../../../../core/widgets/main_loading_widget.dart';
import '../widgets/movie_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(LoadHomeMoviesEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) routeObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    // عند الرجوع، نغير الكاتيجوري randomly
    context.read<MoviesBloc>().add(LoadHomeMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc, MoviesState>(
        buildWhen: (prev, curr) =>
            curr is HomMoviesLoading ||
            curr is HomeMoviesLoaded ||
            curr is HomeMoviesError ||
            curr is MoviesInitial,
        builder: (context, state) {
          if (state is HomMoviesLoading || state is MoviesInitial) {
            return const MainLoadingWidget();
          }

          if (state is HomeMoviesError) {
            return MainErrorWidget(
              massage: state.message,
              onPressed: () =>
                  context.read<MoviesBloc>().add(RefreshMoviesEvent()),
            );
          }

          if (state is HomeMoviesLoaded) {
            return _buildBody(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeMoviesLoaded state) {
    if (state.carouselMovies.isEmpty) {
      return Center(
        child: Text(
          'No Movies Found',
          style: TextStyle(color: AppColors.white),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        SizedBox(
          height: 0.5.sh,
          width: 1.sw,
          child: Image.asset(AppAssets.available, fit: BoxFit.cover),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.gray.withValues(alpha: 0.8),
                AppColors.gray,
              ],
              stops: const [0.0, 0.4, 0.9],
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppAssets.available),
                SizedBox(height: 8.h),

                // Carousel
                CarouselSlider.builder(
                  itemCount: state.carouselMovies.length,
                  itemBuilder: (context, index, _) {
                    final movie = state.carouselMovies[index];
                    return InkWell(
                      onTap: () => _navigateToDetails(context, movie),
                      child: MovieCard(
                        imageUrl: movie.coverImage,
                        rating: movie.rating?.toString() ?? '0',
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 0.45.sh,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.65,
                    enlargeFactor: 0.3,
                  ),
                ),

                Image.asset(AppAssets.watchnow),
                SizedBox(height: 10.h),

                // Category section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.currentCategory, style: AppStyles.bold18White),
                      TextButton.icon(
                        onPressed: () {},
                        label: Text('See More', style: AppStyles.medium15Amber),
                        icon: Icon(Icons.arrow_forward, color: AppColors.amber),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // Horizontal movie list
                SizedBox(
                  height: 0.28.sh,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    itemCount: state.categoryMovies.length,
                    itemBuilder: (context, index) {
                      final movie = state.categoryMovies[index];
                      return AspectRatio(
                        aspectRatio: 2 / 3,
                        child: InkWell(
                          onTap: () => _navigateToDetails(context, movie),
                          child: MovieCard(
                            imageUrl: movie.coverImage,
                            rating: movie.rating?.toString() ?? '0',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context, MovieEntity movie) {
    Navigator.pushNamed(context, AppRoutes.movieDetails, arguments: movie);
  }
}
