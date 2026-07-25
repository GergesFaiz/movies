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
