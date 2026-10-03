import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/movies/domain/entities/movie_details_entity.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies/features/movies/domain/repositories/user_movies_repository.dart';

class FakeMoviesRepository implements MoviesRepository {
  Either<Failure, List<MovieEntity>> moviesResult = const Right([]);
  Either<Failure, List<MovieEntity>> searchResult = const Right([]);
  int getMoviesCalls = 0;

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    String sortBy = 'date_added',
    int limit = 50,
    int page = 1,
  }) async {
    getMoviesCalls++;
    return moviesResult;
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async =>
      searchResult;

  @override
  Future<Either<Failure, MovieDetailsEntity>> getMovieDetails(
    int movieId,
  ) async => const Left(ServerFailure('details not stubbed'));

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovieSuggestions(
    int movieId,
  ) async => const Right([]);
}

class FakeUserMoviesRepository implements UserMoviesRepository {
  final List<MovieEntity> toggled = [];
  final List<MovieEntity> history = [];

  @override
  Future<Either<Failure, void>> toggleWatchlist(MovieEntity movie) async {
    toggled.add(movie);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> addToHistory(MovieEntity movie) async {
    history.add(movie);
    return const Right(null);
  }

  @override
  Stream<bool> isMovieInWatchlist(int movieId) => Stream.value(false);
}

MovieEntity movie(int id, {List<String>? genres}) =>
    MovieEntity(id: id, title: 'Movie $id', genres: genres);
