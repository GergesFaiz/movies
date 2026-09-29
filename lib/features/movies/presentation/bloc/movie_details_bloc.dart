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
  ) : super(const MovieDetailsState()) {
    on<LoadMovieDetailsEvent>(_onLoadMovieDetails);
    on<WatchWatchlistStatusEvent>(_onWatchWatchlistStatus);
    on<ToggleWatchlistEvent>(_onToggleWatchlist);
    on<AddToHistoryEvent>(_onAddToHistory);
  }

  Future<void> _onLoadMovieDetails(
    LoadMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(state.copyWith(status: MovieDetailsStatus.loading));

    final result = await _getMovieDetailsUseCase(event.movieId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MovieDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (details) => emit(
        state.copyWith(status: MovieDetailsStatus.loaded, details: details),
      ),
    );
  }

  Future<void> _onWatchWatchlistStatus(
    WatchWatchlistStatusEvent event,
    Emitter<MovieDetailsState> emit,
  ) {
    return emit.forEach<bool>(
      _isMovieInWatchlistUseCase(event.movieId),
      onData: (isInWatchlist) => state.copyWith(isInWatchlist: isInWatchlist),
      onError: (_, _) => state,
    );
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlistEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    if (state.isTogglingWatchlist) return;

    final wasInWatchlist = state.isInWatchlist;
    emit(
      state.copyWith(isTogglingWatchlist: true, clearWatchlistFeedback: true),
    );

    final result = await _toggleWatchlistUseCase(event.movie);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isTogglingWatchlist: false,
          watchlistError: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isTogglingWatchlist: false,
          isInWatchlist: !wasInWatchlist,
          watchlistAction: wasInWatchlist
              ? WatchlistAction.removed
              : WatchlistAction.added,
        ),
      ),
    );
  }

  Future<void> _onAddToHistory(
    AddToHistoryEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    await _addToHistoryUseCase(event.movie);
  }
}
