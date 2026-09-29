import '../entities/movie_entity.dart';
import '../repositories/user_movies_repository.dart';

class WatchHistoryUseCase {
  final UserMoviesRepository _repository;

  WatchHistoryUseCase(this._repository);

  Stream<List<MovieEntity>> call() => _repository.watchHistory();
}
