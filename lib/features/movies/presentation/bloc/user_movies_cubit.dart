import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/watch_history_usecase.dart';
import '../../domain/usecases/watch_watchlist_usecase.dart';

part 'user_movies_state.dart';

/// Live watchlist and history of the signed-in user (Profile tab).
class UserMoviesCubit extends Cubit<UserMoviesState> {
  final WatchWatchlistUseCase _watchWatchlistUseCase;
  final WatchHistoryUseCase _watchHistoryUseCase;

  StreamSubscription<List<MovieEntity>>? _watchlistSubscription;
  StreamSubscription<List<MovieEntity>>? _historySubscription;

  UserMoviesCubit(this._watchWatchlistUseCase, this._watchHistoryUseCase)
    : super(const UserMoviesState());

  void watch() {
    _watchlistSubscription?.cancel();
    _historySubscription?.cancel();

    _watchlistSubscription = _watchWatchlistUseCase().listen(
      (movies) =>
          emit(state.copyWith(watchlist: movies, isWatchlistLoading: false)),
      onError: (Object error) => emit(
        state.copyWith(
          isWatchlistLoading: false,
          errorMessage: error.toString(),
        ),
      ),
    );

    _historySubscription = _watchHistoryUseCase().listen(
      (movies) =>
          emit(state.copyWith(history: movies, isHistoryLoading: false)),
      onError: (Object error) => emit(
        state.copyWith(isHistoryLoading: false, errorMessage: error.toString()),
      ),
    );
  }

  @override
  Future<void> close() {
    _watchlistSubscription?.cancel();
    _historySubscription?.cancel();
    return super.close();
  }
}
