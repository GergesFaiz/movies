import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';
import 'package:movies/cubit/movie_cubit.dart';
import 'package:movies/states/movie_state.dart';
import 'package:movies/tabs/HomeTab/movie_card.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/main_error_widget.dart';
import 'package:movies/widgets/main_loading_widget.dart';

import 'movie_details.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

List<Movies> mainMoviesList = [];

class _HomeTabState extends State<HomeTab> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    context.read<MoviesCubit>().changeCategoryRandomly(mainMoviesList);
  }

  Future<List<Movies>> fetchMovies() async {
    final response = await RetrofitService(Dio()).getMovies();
    return response.data?.movies ?? [];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mainMoviesList.isNotEmpty) {
        context.read<MoviesCubit>().changeCategoryRandomly(mainMoviesList);
      }
    });
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
          mainMoviesList = moviesList;

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
                                        MovieDetails(movie: moviesList[index]),
                                  ),
                                );
                              },
                              child: MovieCard(
                                image: moviesList[index].mediumCoverImage ?? '',
                                text: moviesList[index].rating?.toString() ?? '0',
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
                        BlocBuilder<MoviesCubit, MoviesState>(
                          builder: (context, state) {
                            String textToShow = 'Action';
                            List<Movies> currentListViewList = moviesList;

                            if (state is CategoryChangedState) {
                              textToShow = state.categoryName;
                              currentListViewList = state.filteredMovies;
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.read<MoviesCubit>().state is MoviesInitial) {
                                  context.read<MoviesCubit>().changeCategoryRandomly(moviesList);
                                }
                              });
                            }
                            
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(textToShow, style: AppStyles.bold18White),
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
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: height * 0.28,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    itemCount: currentListViewList.length,
                                    itemBuilder: (context, index) {
                                      return AspectRatio(
                                        aspectRatio: 2 / 3,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MovieDetails(
                                                    movie: currentListViewList[index]),
                                              ),
                                            );
                                          },
                                          child: MovieCard(
                                            image: currentListViewList[index].mediumCoverImage ?? '',
                                            text: currentListViewList[index].rating?.toString() ?? '0',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
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