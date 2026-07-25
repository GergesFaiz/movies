import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/movie_entity.dart';

/// Owns movie data that belongs to the currently signed-in user.
abstract class UserMoviesRepository {
  Future<Either<Failure, void>> toggleWatchlist(MovieEntity movie);

  Future<Either<Failure, void>> addToHistory(MovieEntity movie);

  Stream<bool> isMovieInWatchlist(int movieId);
}
