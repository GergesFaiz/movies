import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';
import 'package:movies/tabs/HomeTab/movie_card.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/main_error_widget.dart';
import 'package:movies/widgets/main_loading_widget.dart';

import 'movie_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<List<Movies>> fetchMovies() async {
    final response = await RetrofitService(Dio()).getMovies();
    return response.data?.movies ?? [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = context.height;

    return Scaffold(
      body: FutureBuilder(
        future: RetrofitService(Dio()).getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MainLoadingWidget();
          }

          if (snapshot.hasError) {
            return MainErrorWidget(
              massage: snapshot.error.toString(),
              onPressed: () {
                setState(() {});
              },
            );
          }
          List<Movies> moviesList = snapshot.data?.data?.movies ?? [];

          if (moviesList.isEmpty) {
            return Center(
              child: Text(
                'No Movies Found',
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else {
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
                          itemCount: moviesList.length,
                          itemBuilder: (context, index, realIndex) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MovieWidget(movie: moviesList[index]),
                                  ),
                                );
                              },
                              child: MovieCard(
                                image: moviesList[index].mediumCoverImage ?? '',
                                text: moviesList[index].rating?.toString() ??
                                    '0',
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
                              Text('Action', style: AppStyles.bold18White),
                              TextButton.icon(
                                onPressed: () {
                                  print(moviesList.length);
                                },
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
                            itemCount: moviesList.length,
                            itemBuilder: (context, index) {
                              return AspectRatio(
                                aspectRatio: 2 / 3,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MovieWidget(
                                                movie: moviesList[index]),
                                      ),
                                    );
                                  },
                                  child: MovieCard(
                                    image:
                                    moviesList[index].mediumCoverImage ?? '',
                                    text:
                                    moviesList[index].rating?.toString() ??
                                        '0',
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
        },
      ),
    );
  }
}
