import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/model/movies.dart';
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
import 'home_view_model.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

List<Movies> mainMoviesList = [];

class _HomeTabState extends State<HomeTab> with RouteAware {
  //  هنا تعريف الـ viewModel عشان الإيرور يختفي تماماً
  late HomeViewModel viewModel;

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

  @override
  void initState() {
    super.initState();
    // تهيئة الـ viewModel عند بداية الشاشة
    viewModel = HomeViewModel();
    viewModel.loadHomeMovies();
    viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = context.height;
    return Scaffold(
      body: buildBody(height),
    );
  }

  Widget buildBody(double height) {
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
            AppAssets.available, // اتأكدي من مسار الصورة الصحيح هنا لو مختلفة
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
                SizedBox(height: context.height * 0.01),
                BlocBuilder<MoviesCubit, MoviesState>(
                  builder: (context, state) {
                    String textToShow = 'Action';
                    List<Movies> currentListViewList = viewModel.moviesList;

                    if (state is CategoryChangedState) {
                      textToShow = state.categoryName;
                      currentListViewList = state.filteredMovies;
                    } else {
                     
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.read<MoviesCubit>().state is MoviesInitial) {
                          context.read<MoviesCubit>().changeCategoryRandomly(viewModel.moviesList);
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
                              Text(
                                textToShow,
                                style: AppStyles.bold18White,
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  print(viewModel.moviesList.length);
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
                        SizedBox(height: context.height * 0.01),
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
                                          movie: currentListViewList[index],
                                        ),
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
                SizedBox(height: context.height * 0.02),
              ],
            ),
          ),
        ),
      ],
    );
  }
}