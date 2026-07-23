import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/user_movies_repository.dart';

class ToggleWatchlistUseCase implements UseCase<void, MovieEntity> {
  final UserMoviesRepository _repository;

  ToggleWatchlistUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(MovieEntity movie) {
    return _repository.toggleWatchlist(movie);
  }
}
