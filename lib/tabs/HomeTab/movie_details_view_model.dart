import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:movies/api/retrofit_service.dart';
import 'package:movies/api/model/movies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MovieDetailsViewModel extends ChangeNotifier {
  final RetrofitService _apiService = RetrofitService(Dio());
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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

  Future<void> toggleWatchlist(Movies movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('Users').doc(user.uid);
    final movieImage = movie.mediumCoverImage ?? movie.largeCoverImage ?? '';
    
    final movieData = {
      'id': movie.id,
      'title': movie.title,
      'rating': movie.rating,
      'image_url': movieImage,
      'poster_path': movieImage,
      'medium_cover_image': movieImage,
    };

    final snapshot = await userDoc.get();
    
    if (!snapshot.exists) {
      await userDoc.set({
        'watchlist': [movieData],
        'history': []
      }, SetOptions(merge: true));
      notifyListeners();
      return;
    }

    final List<dynamic> watchlist = snapshot.data()?['watchlist'] ?? [];
    bool isExist = watchlist.any((item) => item['id'] == movie.id);

    if (isExist) {
      await userDoc.set({
        'watchlist': FieldValue.arrayRemove([watchlist.firstWhere((item) => item['id'] == movie.id)])
      }, SetOptions(merge: true));
    } else {
      await userDoc.set({
        'watchlist': FieldValue.arrayUnion([movieData])
      }, SetOptions(merge: true));
    }
    notifyListeners();
  }

  Future<void> addToHistory(Movies movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('Users').doc(user.uid);
    final movieImage = movie.mediumCoverImage ?? movie.largeCoverImage ?? '';

    final movieData = {
      'id': movie.id,
      'title': movie.title,
      'rating': movie.rating,
      'image_url': movieImage,
      'poster_path': movieImage,
      'medium_cover_image': movieImage,
    };

    await userDoc.set({
      'history': FieldValue.arrayUnion([movieData])
    }, SetOptions(merge: true));
    
    notifyListeners();
  }

  Stream<bool> isMovieInWatchlist(int movieId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore.collection('Users').doc(user.uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return false;
      final List<dynamic> watchlist = snapshot.data()?['watchlist'] ?? [];
      return watchlist.any((item) => item['id'] == movieId);
    });
  }
}