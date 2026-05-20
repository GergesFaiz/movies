import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movies/api/retrofit_service.dart';
import 'package:movies/api/model/movies.dart';

class MovieDetailsViewModel extends ChangeNotifier {
  final RetrofitService _apiService = RetrofitService(Dio());

  bool isLoading = false;
  String? errorMessage;
  
  String likeCount = '0';
  int runtime = 0;
  double rating = 0.0;
  List<String> genres = [];
  List<String> screenshots = [];
  List<dynamic> cast = [];
  List<Movies> suggestions = [];

  Future<void> loadMovieData(int movieId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); 

    try {
      final detailResponse = await _apiService.getMovieDetails(movieId: movieId);
      final responseData = detailResponse.data as Map<String, dynamic>?;
      final movieData = responseData?['data']?['movie'];

      if (movieData != null) {
        likeCount = movieData['like_count']?.toString() ?? '0';
        runtime = movieData['runtime'] ?? 0;
        rating = (movieData['rating'] as num?)?.toDouble() ?? 0.0;
        
        final genresList = movieData['genres'] as List<dynamic>?;
        if (genresList != null) {
          genres = genresList.map((g) => g.toString()).toList();
        } else {
          genres = [];
        }

        screenshots.clear();
        if (movieData['medium_screenshot_image1'] != null) screenshots.add(movieData['medium_screenshot_image1']);
        if (movieData['medium_screenshot_image2'] != null) screenshots.add(movieData['medium_screenshot_image2']);
        if (movieData['medium_screenshot_image3'] != null) screenshots.add(movieData['medium_screenshot_image3']);

        cast = movieData['cast'] as List<dynamic>? ?? [];
      }

      final suggestionResponse = await _apiService.getMovieSuggestions(movieId: movieId);
      suggestions = suggestionResponse.data?.movies ?? [];

    } catch (e) {
      errorMessage = "Failed to load movie data. Please try again.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}