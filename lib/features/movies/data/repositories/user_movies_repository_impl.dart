import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/user_movies_repository.dart';
import '../datasources/user_movies_remote_datasource.dart';
import '../models/movie_model.dart';

class UserMoviesRepositoryImpl implements UserMoviesRepository {
  final UserMoviesRemoteDataSource _remoteDataSource;

  UserMoviesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> toggleWatchlist(MovieEntity movie) {
    return _run(
      () => _remoteDataSource.toggleWatchlist(MovieModel.fromEntity(movie)),
    );
  }

  @override
  Future<Either<Failure, void>> addToHistory(MovieEntity movie) {
    return _run(
      () => _remoteDataSource.addToHistory(MovieModel.fromEntity(movie)),
    );
  }

  @override
  Stream<bool> isMovieInWatchlist(int movieId) {
    return _remoteDataSource.isMovieInWatchlist(movieId);
  }

  Future<Either<Failure, void>> _run(Future<void> Function() action) async {
    try {
      await action();
      return const Right(null);
    } on FirebaseException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Unable to update your movies.'),
      );
    } on StateError catch (error) {
      return Left(AuthFailure(error.message));
    } catch (_) {
      return const Left(ServerFailure('Unable to update your movies.'));
    }
  }
}
