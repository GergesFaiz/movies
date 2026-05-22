import 'package:movies/api/model/movies.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movies> allMovies;
  final List<Movies> carouselMovies;
  final List<Movies> currentCategoryMovies;
  final String currentCategoryName;

  HomeLoaded({
    required this.allMovies,
    required this.carouselMovies,
    required this.currentCategoryMovies,
    required this.currentCategoryName,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
