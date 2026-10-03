import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final GetMoviesUseCase _getBrowseMoviesUseCase;

  List<MovieEntity> _allMovies = [];

  MoviesCubit(this._getMoviesUseCase, this._getBrowseMoviesUseCase)
    : super(MoviesInitial());

  // ─── Home ─────────────────────────────────────────────────────────────────

  Future<void> loadHomeMovies() async {
    if (_allMovies.isNotEmpty) {
      _emitRandomCategory();
      return;
    }

    emit(HomMoviesLoading());

    final result = await _getMoviesUseCase(const GetMoviesParams(limit: 100));

    result.fold((failure) => emit(HomeMoviesError(failure.message)), (movies) {
      _allMovies = movies;
      _emitRandomCategory();
    });
  }

  void changeCategory(String category) {
    if (state is! HomeMoviesLoaded) return;
    final current = state as HomeMoviesLoaded;
    emit(
      current.copyWith(
        categoryMovies: _filterByCategory(category),
        currentCategory: category,
      ),
    );
  }

  void _emitRandomCategory() {
    if (_allMovies.isEmpty) return;

    final allGenres = <String>{};
    for (final movie in _allMovies) {
      for (final g in movie.genres ?? []) {
        allGenres.add(g);
      }
    }

    String selectedGenre;
    if (allGenres.isEmpty) {
      selectedGenre = 'All';
    } else {
      final list = allGenres.toList();
      selectedGenre = list[Random().nextInt(list.length)];
    }

    final displayName =
        selectedGenre[0].toUpperCase() +
        selectedGenre.substring(1).toLowerCase();

    emit(
      HomeMoviesLoaded(
        carouselMovies: _allMovies.take(10).toList(),
        categoryMovies: _filterByCategory(selectedGenre),
        currentCategory: displayName,
      ),
    );
  }

  Future<void> refresh() async {
    _allMovies.clear();
    await loadHomeMovies();
  }

  // ─── Browse ───────────────────────────────────────────────────────────────

  Future<void> loadBrowseMovies() async {
    emit(BrowseMoviesLoading());

    final result = await _getBrowseMoviesUseCase(
      const GetMoviesParams(limit: 250, sortBy: 'rating'),
    );

    result.fold((failure) => emit(BrowseMoviesError(failure.message)), (
      movies,
    ) {
      final genresSet = <String>{};
      for (final movie in movies) {
        genresSet.addAll(movie.genres ?? []);
      }
      final genres = ['All', ...genresSet.toList()..sort()];

      emit(
        BrowseMoviesLoaded(
          movies: movies,
          allMovies: movies,
          genres: genres,
          selectedGenre: 'All',
        ),
      );
    });
  }

  void selectGenre(String genre) {
    if (state is! BrowseMoviesLoaded) return;
    final current = state as BrowseMoviesLoaded;
    final filtered = genre == 'All'
        ? current.allMovies
        : current.allMovies
              .where((m) => m.genres?.contains(genre) ?? false)
              .toList();

    emit(current.copyWith(movies: filtered, selectedGenre: genre));
  }

  List<MovieEntity> _filterByCategory(String category) {
    if (category.toLowerCase() == 'all') return _allMovies;
    return _allMovies
        .where(
          (m) =>
              m.genres
                  ?.map((g) => g.toLowerCase())
                  .contains(category.toLowerCase()) ??
              false,
        )
        .toList();
  }
}
