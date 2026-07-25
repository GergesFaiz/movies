import '../repositories/user_movies_repository.dart';

class IsMovieInWatchlistUseCase {
  final UserMoviesRepository _repository;

  IsMovieInWatchlistUseCase(this._repository);

  Stream<bool> call(int movieId) => _repository.isMovieInWatchlist(movieId);
}
