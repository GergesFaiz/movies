import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/tabs/HomeTab/movie_card.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/main_error_widget.dart';
import 'package:movies/widgets/main_loading_widget.dart';
import 'movie_details.dart';
import 'home_view_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadHomeMovies();
    viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = context.height;

    return Scaffold(
      body: _buildBody(height),
    );
  }

  Widget _buildBody(double height) {
    if (viewModel.isLoading) {
      return const MainLoadingWidget();
    }

    if (viewModel.errorMessage != null) {
      return MainErrorWidget(
        massage: viewModel.errorMessage!,
        onPressed: () {
          viewModel.refreshData();
        },
      );
    }

    if (viewModel.moviesList.isEmpty) {
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
          height: context.height * 0.5,
          width: context.width,
          child: Image.asset(
            AppOnboardingImage.onbaordingImage6,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: context.height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.gray.withOpacity(0.8),
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
                const SizedBox(height: 8),
                CarouselSlider.builder(
                  itemCount: viewModel.moviesList.length,
                  itemBuilder: (context, index, realIndex) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetails(
                              movie: viewModel.moviesList[index],
                            ),
                          ),
                        );
                      },
                      child: MovieCard(
                        image: viewModel.moviesList[index].mediumCoverImage ?? '',
                        text: viewModel.moviesList[index].rating?.toString() ?? '0',
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: height * 0.45,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.65,
                    enlargeFactor: 0.3,
                  ),
                ),
                Image.asset(AppAssets.watchnow),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(viewModel.currentGenre, style: AppStyles.bold18White),
                      TextButton.icon(
                        onPressed: () {},
                        label: Text(
                          'See More',
                          style: AppStyles.medium15Amber,
                        ),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AppColors.amber,
                        ),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.28,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: viewModel.dynamicMoviesList.length,
                    itemBuilder: (context, index) {
                      final dynamicMovie = viewModel.dynamicMoviesList[index];
                      return AspectRatio(
                        aspectRatio: 2 / 3,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetails(
                                  movie: dynamicMovie,
                                ),
                              ),
                            );
                          },
                          child: MovieCard(
                            image: dynamicMovie.mediumCoverImage ?? '',
                            text: dynamicMovie.rating?.toString() ?? '0',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}