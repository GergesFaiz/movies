part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

// ─── Home States ──────────────────────────────────────────────────────────────

class HomMoviesLoading extends MoviesState {}

class HomeMoviesLoaded extends MoviesState {
  final List<MovieEntity> carouselMovies;
  final List<MovieEntity> categoryMovies;
  final String currentCategory;

  const HomeMoviesLoaded({
    required this.carouselMovies,
    required this.categoryMovies,
    required this.currentCategory,
  });

  HomeMoviesLoaded copyWith({
    List<MovieEntity>? carouselMovies,
    List<MovieEntity>? categoryMovies,
    String? currentCategory,
  }) {
    return HomeMoviesLoaded(
      carouselMovies: carouselMovies ?? this.carouselMovies,
      categoryMovies: categoryMovies ?? this.categoryMovies,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }

  @override
  List<Object?> get props => [carouselMovies, categoryMovies, currentCategory];
}

class HomeMoviesError extends MoviesState {
  final String message;

  const HomeMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Browse States ────────────────────────────────────────────────────────────

class BrowseMoviesLoading extends MoviesState {}

class BrowseMoviesLoaded extends MoviesState {
  final List<MovieEntity> movies;
  final List<MovieEntity> allMovies;
  final List<String> genres;
  final String selectedGenre;

  const BrowseMoviesLoaded({
    required this.movies,
    required this.allMovies,
    required this.genres,
    required this.selectedGenre,
  });

  BrowseMoviesLoaded copyWith({
    List<MovieEntity>? movies,
    List<MovieEntity>? allMovies,
    List<String>? genres,
    String? selectedGenre,
  }) {
    return BrowseMoviesLoaded(
      movies: movies ?? this.movies,
      allMovies: allMovies ?? this.allMovies,
      genres: genres ?? this.genres,
      selectedGenre: selectedGenre ?? this.selectedGenre,
    );
  }

  @override
  List<Object?> get props => [movies, allMovies, genres, selectedGenre];
}

class BrowseMoviesError extends MoviesState {
  final String message;

  const BrowseMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
