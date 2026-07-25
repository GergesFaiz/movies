import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getMovies({String sortBy, int limit, int page});

  Future<Map<String, dynamic>> getMovieDetails(int movieId);

  Future<List<MovieModel>> getMovieSuggestions(int movieId);

  Future<List<MovieModel>> searchMovies(String query);
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final ApiClient _apiClient;

  MoviesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<MovieModel>> getMovies({
    String sortBy = 'date_added',
    int limit = 50,
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.getMovies(
        sortBy: sortBy,
        limit: limit,
        page: page,
      );
      return response.data?.movies ?? [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    try {
      final response = await _apiClient.getMovieDetails(movieId: movieId);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    try {
      final response = await _apiClient.getMovieSuggestions(movieId: movieId);
      return response.data?.movies ?? [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _apiClient.getMovies(queryTerm: query, limit: 50);
      return response.data?.movies ?? [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timed out');
    } else if (e.response?.statusCode == 404) {
      return const NotFoundFailure('No results found');
    }
    return ServerFailure(e.message ?? 'Server error');
  }
}
