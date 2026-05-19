import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movies/api/retrofit_service.dart';
import 'package:movies/api/model/movies.dart';

class HomeViewModel extends ChangeNotifier {
  final RetrofitService _apiService = RetrofitService(Dio());

  bool isLoading = false;
  String? errorMessage;
  List<Movies> moviesList = [];
  List<Movies> dynamicMoviesList = [];
  String currentGenre = 'Action';

  Future<void> loadHomeMovies() async {
    if (moviesList.isNotEmpty) {
      changeGenreRandomly();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getMovies();
      moviesList = response.data?.movies ?? [];
      changeGenreRandomly();
    } catch (e) {
      errorMessage = "Failed to load movies. Please try again.";
      isLoading = false;
      notifyListeners();
    }
  }

  void changeGenreRandomly() {
    if (moviesList.isEmpty) return;

    Set<String> allGenres = {};
    for (var movie in moviesList) {
      if (movie.genres != null) {
        for (var g in movie.genres!) {
          allGenres.add(g.toString());
        }
      }
    }

    if (allGenres.isEmpty) {
      dynamicMoviesList = moviesList;
      currentGenre = 'All';
      isLoading = false;
      notifyListeners();
      return;
    }

    List<String> genresList = allGenres.toList();
    final random = Random();
    
    String selectedGenre = genresList[random.nextInt(genresList.length)];
    currentGenre = selectedGenre[0].toUpperCase() + selectedGenre.substring(1).toLowerCase();

    dynamicMoviesList = moviesList.where((movie) {
      final genres = movie.genres?.map((g) => g.toString().toLowerCase()).toList() ?? [];
      return genres.contains(selectedGenre.toLowerCase());
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  void refreshData() {
    moviesList.clear();
    dynamicMoviesList.clear();
    loadHomeMovies();
  }
}