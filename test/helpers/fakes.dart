import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/auth/domain/entities/user_entity.dart';
import 'package:movies/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies/features/movies/data/datasources/movies_remote_datasource.dart';
import 'package:movies/features/movies/data/models/movie_model.dart';
import 'package:movies/features/movies/domain/entities/movie_details_entity.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/movies/domain/repositories/movies_repository.dart';
import 'package:movies/features/movies/domain/repositories/user_movies_repository.dart';

class FakeMoviesRepository implements MoviesRepository {
  Either<Failure, List<MovieEntity>> moviesResult = const Right([]);
  Either<Failure, MovieDetailsEntity>? detailsResult;
  Either<Failure, List<MovieEntity>> suggestionsResult = const Right([]);

  /// Search results by query; unknown queries return an empty list.
  final Map<String, List<MovieEntity>> searchResults = {};
  final List<String> searchCalls = [];

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    String sortBy = 'date_added',
    int limit = 50,
    int page = 1,
  }) async => moviesResult;

  @override
  Future<Either<Failure, MovieDetailsEntity>> getMovieDetails(
    int movieId,
  ) async => detailsResult!;

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovieSuggestions(
    int movieId,
  ) async => suggestionsResult;

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    searchCalls.add(query);
    return Right(searchResults[query] ?? const []);
  }
}

class FakeMoviesRemoteDataSource implements MoviesRemoteDataSource {
  MovieModel? details;
  Object? detailsError;
  List<MovieModel> suggestions = const [];
  Object? suggestionsError;

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    if (detailsError != null) throw detailsError!;
    return details!;
  }

  @override
  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    if (suggestionsError != null) throw suggestionsError!;
    return suggestions;
  }

  @override
  Future<List<MovieModel>> getMovies({
    String sortBy = 'date_added',
    int limit = 50,
    int page = 1,
  }) async => const [];

  @override
  Future<List<MovieModel>> searchMovies(String query) async => const [];
}

class FakeUserMoviesRepository implements UserMoviesRepository {
  final StreamController<bool> watchlistStatus =
      StreamController<bool>.broadcast();
  Either<Failure, void> toggleResult = const Right(null);
  final List<MovieEntity> history = [];

  @override
  Future<Either<Failure, void>> addToHistory(MovieEntity movie) async {
    history.add(movie);
    return const Right(null);
  }

  @override
  Stream<bool> isMovieInWatchlist(int movieId) => watchlistStatus.stream;

  @override
  Future<Either<Failure, void>> toggleWatchlist(MovieEntity movie) async =>
      toggleResult;

  @override
  Stream<List<MovieEntity>> watchHistory() => const Stream.empty();

  @override
  Stream<List<MovieEntity>> watchWatchlist() => const Stream.empty();
}

class FakeAuthRepository implements AuthRepository {
  Either<Failure, void> result = const Right(null);
  final StreamController<UserEntity?> users =
      StreamController<UserEntity?>.broadcast();
  final List<String> calls = [];
  Map<String, String>? lastRegistration;
  Map<String, String>? lastUpdate;

  @override
  bool get isLoggedIn => true;

  @override
  Future<Either<Failure, void>> login(String email, String password) async {
    calls.add('login');
    return result;
  }

  @override
  Future<Either<Failure, void>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    calls.add('register');
    lastRegistration = {
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
    return result;
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    calls.add('forgotPassword');
    return result;
  }

  @override
  Future<Either<Failure, void>> logout() async {
    calls.add('logout');
    return result;
  }

  @override
  Stream<UserEntity?> watchCurrentUser() => users.stream;

  @override
  Future<Either<Failure, void>> updateProfile({
    required String name,
    required String phone,
    required String avatar,
  }) async {
    calls.add('updateProfile');
    lastUpdate = {'name': name, 'phone': phone, 'avatar': avatar};
    return result;
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    calls.add('deleteAccount');
    return result;
  }
}
