part of 'user_movies_cubit.dart';

class UserMoviesState extends Equatable {
  final bool isWatchlistLoading;
  final bool isHistoryLoading;
  final List<MovieEntity> watchlist;
  final List<MovieEntity> history;
  final String? errorMessage;

  const UserMoviesState({
    this.isWatchlistLoading = true,
    this.isHistoryLoading = true,
    this.watchlist = const [],
    this.history = const [],
    this.errorMessage,
  });

  UserMoviesState copyWith({
    bool? isWatchlistLoading,
    bool? isHistoryLoading,
    List<MovieEntity>? watchlist,
    List<MovieEntity>? history,
    String? errorMessage,
  }) {
    return UserMoviesState(
      isWatchlistLoading: isWatchlistLoading ?? this.isWatchlistLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      watchlist: watchlist ?? this.watchlist,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isWatchlistLoading,
    isHistoryLoading,
    watchlist,
    history,
    errorMessage,
  ];
}
