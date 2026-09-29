import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getMovies({String sortBy, int limit, int page});

  Future<MovieModel> getMovieDetails(int movieId);

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
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await _apiClient.getMovieDetails(movieId: movieId);
      final body = response.data;
      final data = body is Map<String, dynamic> ? body['data'] : null;
      final movie = data is Map<String, dynamic> ? data['movie'] : null;
      if (movie is! Map<String, dynamic>) {
        throw const NotFoundFailure('Movie data not found');
      }
      return MovieModel.fromJson(movie);
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
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkFailure('Connection timed out');
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      default:
        if (e.response?.statusCode == 404) {
          return const NotFoundFailure('No results found');
        }
        return ServerFailure(e.message ?? 'Server error');
    }
  }
}
