import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_datasource.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource _remoteDataSource;

  MoviesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    String sortBy = 'date_added',
    int limit = 50,
    int page = 1,
  }) async {
    try {
      final movies = await _remoteDataSource.getMovies(
        sortBy: sortBy,
        limit: limit,
        page: page,
      );
      return Right(movies.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieDetailsEntity>> getMovieDetails(
    int movieId,
  ) async {
    try {
      final rawData = await _remoteDataSource.getMovieDetails(movieId);
      final movieData =
          (rawData['data'] as Map<String, dynamic>?)?['movie']
              as Map<String, dynamic>?;

      if (movieData == null) {
        return const Left(ServerFailure('Movie data not found'));
      }

      final likeCount = movieData['like_count']?.toString() ?? '0';
      final runtime = (movieData['runtime'] as num?)?.toInt() ?? 0;
      final rating = (movieData['rating'] as num?)?.toDouble() ?? 0.0;
      final genres =
          (movieData['genres'] as List<dynamic>?)
              ?.map((g) => g.toString())
              .toList() ??
          [];

      final screenshots = <String>[];
      for (int i = 1; i <= 3; i++) {
        final url = movieData['medium_screenshot_image$i'];
        if (url != null) screenshots.add(url.toString());
      }

      final cast = (movieData['cast'] as List<dynamic>?) ?? [];

      final suggestions = await _remoteDataSource.getMovieSuggestions(movieId);

      return Right(
        MovieDetailsEntity(
          likeCount: likeCount,
          runtime: runtime,
          rating: rating,
          genres: genres,
          screenshots: screenshots,
          cast: cast,
          suggestions: suggestions.map((m) => m.toEntity()).toList(),
        ),
      );
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovieSuggestions(
    int movieId,
  ) async {
    try {
      final movies = await _remoteDataSource.getMovieSuggestions(movieId);
      return Right(movies.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      final movies = await _remoteDataSource.searchMovies(query);
      return Right(movies.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
