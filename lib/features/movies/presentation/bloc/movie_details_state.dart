part of 'movie_details_bloc.dart';

enum MovieDetailsStatus { loading, loaded, failure }

enum WatchlistAction { added, removed }

class MovieDetailsState extends Equatable {
  final MovieDetailsStatus status;
  final MovieDetailsEntity? details;
  final String? errorMessage;

  final bool isInWatchlist;
  final bool isTogglingWatchlist;

  /// Result of the last watchlist toggle, consumed by the page to show a
  /// snack bar. Reset to `null` before every toggle.
  final WatchlistAction? watchlistAction;
  final String? watchlistError;

  const MovieDetailsState({
    this.status = MovieDetailsStatus.loading,
    this.details,
    this.errorMessage,
    this.isInWatchlist = false,
    this.isTogglingWatchlist = false,
    this.watchlistAction,
    this.watchlistError,
  });

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    MovieDetailsEntity? details,
    String? errorMessage,
    bool? isInWatchlist,
    bool? isTogglingWatchlist,
    WatchlistAction? watchlistAction,
    String? watchlistError,
    bool clearWatchlistFeedback = false,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage ?? this.errorMessage,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      isTogglingWatchlist: isTogglingWatchlist ?? this.isTogglingWatchlist,
      watchlistAction: clearWatchlistFeedback
          ? null
          : (watchlistAction ?? this.watchlistAction),
      watchlistError: clearWatchlistFeedback
          ? null
          : (watchlistError ?? this.watchlistError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    details,
    errorMessage,
    isInWatchlist,
    isTogglingWatchlist,
    watchlistAction,
    watchlistError,
  ];
}
