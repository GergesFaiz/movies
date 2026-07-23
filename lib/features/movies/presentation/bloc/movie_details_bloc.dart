import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_details_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/add_to_history_usecase.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import '../../domain/usecases/is_movie_in_watchlist_usecase.dart';
import '../../domain/usecases/toggle_watchlist_usecase.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetailsUseCase _getMovieDetailsUseCase;
  final ToggleWatchlistUseCase _toggleWatchlistUseCase;
  final AddToHistoryUseCase _addToHistoryUseCase;
  final IsMovieInWatchlistUseCase _isMovieInWatchlistUseCase;

  MovieDetailsBloc(
    this._getMovieDetailsUseCase,
    this._toggleWatchlistUseCase,
    this._addToHistoryUseCase,
    this._isMovieInWatchlistUseCase,
  ) : super(MovieDetailsInitial()) {
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
    on<ToggleWatchlistEvent>(_onToggleWatchlist);
    on<AddToHistoryEvent>(_onAddToHistory);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    final result = await _getMovieDetailsUseCase(event.movieId);

    result.fold(
      (failure) => emit(MovieDetailsError(failure.message)),
      (details) => emit(MovieDetailsLoaded(details: details)),
    );
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlistEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    await _toggleWatchlistUseCase(event.movie);
  }

  Future<void> _onAddToHistory(
    AddToHistoryEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    await _addToHistoryUseCase(event.movie);
  }

  Stream<bool> isMovieInWatchlist(int movieId) {
    return _isMovieInWatchlistUseCase(movieId);
  }
}
