import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';

import 'home_state.dart';

class HomeTabViewModel extends Cubit<HomeState> {
  HomeTabViewModel() : super(HomeInitial());

  final RetrofitService _apiService = RetrofitService(Dio());

  List<Movies> allMovies = [];
  List<Movies> carouselMovies = [];
  String currentCategory = "Action";

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    try {
      final response = await _apiService.getMovies(limit: 100);
      allMovies = response.data?.movies ?? [];

      // Carousel: أول 10 أفلام (أو حسب اللي عاوزه)
      carouselMovies = allMovies.take(10).toList();

      emit(
        HomeLoaded(
          allMovies: allMovies,
          carouselMovies: carouselMovies,
          currentCategoryMovies: _getMoviesByCategory(currentCategory),
          currentCategoryName: currentCategory,
        ),
      );
    } catch (e) {
      emit(HomeError(message: "Failed to load home data"));
    }
  }

  void changeCategory(String category) {
    currentCategory = category;
    emit(
      HomeLoaded(
        allMovies: allMovies,
        carouselMovies: carouselMovies,
        currentCategoryMovies: _getMoviesByCategory(category),
        currentCategoryName: category,
      ),
    );
  }

  List<Movies> _getMoviesByCategory(String category) {
    if (category == "All") return allMovies;
    return allMovies
        .where((movie) => movie.genres?.contains(category) ?? false)
        .toList();
  }
}
