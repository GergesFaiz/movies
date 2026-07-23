part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeMoviesEvent extends MoviesEvent {}

class ChangeCategoryEvent extends MoviesEvent {
  final String category;

  const ChangeCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class LoadBrowseMoviesEvent extends MoviesEvent {}

class SelectGenreEvent extends MoviesEvent {
  final String genre;

  const SelectGenreEvent(this.genre);

  @override
  List<Object?> get props => [genre];
}

class RefreshMoviesEvent extends MoviesEvent {}
