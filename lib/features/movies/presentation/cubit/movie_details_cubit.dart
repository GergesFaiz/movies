import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/add_to_history_usecase.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import '../../domain/usecases/is_movie_in_watchlist_usecase.dart';
import '../../domain/usecases/toggle_watchlist_usecase.dart';
import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final ToggleWatchlistUseCase _toggleWatchlistUseCase;
  final AddToHistoryUseCase _addToHistoryUseCase;
  final IsMovieInWatchlistUseCase _isMovieInWatchlistUseCase;

  MovieDetailsCubit(
    this._getMovieDetailsUseCase,
    this._toggleWatchlistUseCase,
    this._addToHistoryUseCase,
    this._isMovieInWatchlistUseCase,
  ) : super(MovieDetailsInitial());

  Future<void> loadMovieDetails(int movieId) async {
    emit(MovieDetailsLoading());

    final result = await _getMovieDetailsUseCase(movieId);

    result.fold(
      (failure) => emit(MovieDetailsError(failure.message)),
      (details) => emit(MovieDetailsLoaded(details: details)),
    );
  }

  Future<void> toggleWatchlist(MovieEntity movie) async {
    await _toggleWatchlistUseCase(movie);
  }

  Future<void> addToHistory(MovieEntity movie) async {
    await _addToHistoryUseCase(movie);
  }

  Stream<bool> isMovieInWatchlist(int movieId) {
    return _isMovieInWatchlistUseCase(movieId);
  }
}
