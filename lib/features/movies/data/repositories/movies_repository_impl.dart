import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_datasource.dart';
import '../models/movie_model.dart';

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
      // Suggestions are optional: a failure there must not hide the details.
      final suggestionsFuture = _remoteDataSource
          .getMovieSuggestions(movieId)
          .catchError((Object _) => <MovieModel>[]);
      final movie = await _remoteDataSource.getMovieDetails(movieId);
      final suggestions = await suggestionsFuture;

      return Right(
        MovieDetailsEntity(
          movie: movie.toEntity(),
          suggestions: suggestions
              .where((m) => m.id != movieId)
              .map((m) => m.toEntity())
              .toList(),
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
