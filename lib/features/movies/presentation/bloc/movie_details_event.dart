part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovieDetailsEvent extends MovieDetailsEvent {
  final int movieId;

  const LoadMovieDetailsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

/// Starts listening to whether the movie is in the user's watchlist.
class WatchWatchlistStatusEvent extends MovieDetailsEvent {
  final int movieId;

  const WatchWatchlistStatusEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class ToggleWatchlistEvent extends MovieDetailsEvent {
  final MovieEntity movie;

  const ToggleWatchlistEvent(this.movie);

  @override
  List<Object?> get props => [movie.id];
}

class AddToHistoryEvent extends MovieDetailsEvent {
  final MovieEntity movie;

  const AddToHistoryEvent(this.movie);

  @override
  List<Object?> get props => [movie.id];
}
