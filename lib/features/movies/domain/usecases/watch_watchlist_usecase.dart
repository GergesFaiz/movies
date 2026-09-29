import '../entities/movie_entity.dart';
import '../repositories/user_movies_repository.dart';

class WatchWatchlistUseCase {
  final UserMoviesRepository _repository;

  WatchWatchlistUseCase(this._repository);

  Stream<List<MovieEntity>> call() => _repository.watchWatchlist();
}
