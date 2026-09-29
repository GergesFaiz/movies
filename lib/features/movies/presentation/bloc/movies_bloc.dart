import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_movies_usecase.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  /// Genre key meaning "no filter". The UI shows a translated label for it.
  static const String allGenres = 'All';

  final GetMoviesUseCase _getMoviesUseCase;
  final GetMoviesUseCase _getBrowseMoviesUseCase;

  List<MovieEntity> _allMovies = [];

  /// Genre requested (e.g. from Home's "See More") before browse movies
  /// finished loading. Applied as soon as they arrive.
  String? _pendingGenre;

  MoviesBloc(this._getMoviesUseCase, this._getBrowseMoviesUseCase)
    : super(MoviesInitial()) {
    on<LoadHomeMoviesEvent>(_onLoadHomeMovies);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<LoadBrowseMoviesEvent>(_onLoadBrowseMovies);
    on<SelectGenreEvent>(_onSelectGenre);
    on<RefreshMoviesEvent>(_onRefresh);
  }

  // ─── Home ─────────────────────────────────────────────────────────────────

  Future<void> _onLoadHomeMovies(
    LoadHomeMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    if (_allMovies.isNotEmpty) {
      _emitRandomCategory(emit);
      return;
    }

    emit(HomMoviesLoading());

    final result = await _getMoviesUseCase(const GetMoviesParams(limit: 100));

    result.fold((failure) => emit(HomeMoviesError(failure.message)), (movies) {
      _allMovies = movies;
      _emitRandomCategory(emit);
    });
  }

  void _onChangeCategory(ChangeCategoryEvent event, Emitter<MoviesState> emit) {
    if (state is! HomeMoviesLoaded) return;
    final current = state as HomeMoviesLoaded;
    emit(
      current.copyWith(
        categoryMovies: _filterByCategory(event.category),
        currentCategory: event.category,
      ),
    );
  }

  void _emitRandomCategory(Emitter<MoviesState> emit) {
    if (_allMovies.isEmpty) {
      emit(
        const HomeMoviesLoaded(
          carouselMovies: [],
          categoryMovies: [],
          currentCategory: allGenres,
        ),
      );
      return;
    }

    final genres = <String>{};
    for (final movie in _allMovies) {
      genres.addAll(movie.genres ?? const []);
    }

    String selectedGenre;
    if (genres.isEmpty) {
      selectedGenre = allGenres;
    } else {
      final list = genres.toList();
      selectedGenre = list[Random().nextInt(list.length)];
    }

    emit(
      HomeMoviesLoaded(
        carouselMovies: _allMovies.take(10).toList(),
        categoryMovies: _filterByCategory(selectedGenre),
        currentCategory: selectedGenre,
      ),
    );
  }

  // ─── Browse ───────────────────────────────────────────────────────────────

  Future<void> _onLoadBrowseMovies(
    LoadBrowseMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
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
      final genres = [allGenres, ...genresSet.toList()..sort()];

      final loaded = BrowseMoviesLoaded(
        movies: movies,
        allMovies: movies,
        genres: genres,
        selectedGenre: allGenres,
      );

      final pendingGenre = _pendingGenre;
      _pendingGenre = null;
      emit(pendingGenre == null ? loaded : _withGenre(loaded, pendingGenre));
    });
  }

  void _onSelectGenre(SelectGenreEvent event, Emitter<MoviesState> emit) {
    final current = state;
    if (current is! BrowseMoviesLoaded) {
      _pendingGenre = event.genre;
      return;
    }
    emit(_withGenre(current, event.genre));
  }

  BrowseMoviesLoaded _withGenre(BrowseMoviesLoaded current, String genre) {
    // Match case-insensitively and fall back to "All" for unknown genres.
    final selected = current.genres.firstWhere(
      (g) => g.toLowerCase() == genre.toLowerCase(),
      orElse: () => allGenres,
    );
    final filtered = selected == allGenres
        ? current.allMovies
        : current.allMovies
              .where((m) => m.genres?.contains(selected) ?? false)
              .toList();

    return current.copyWith(movies: filtered, selectedGenre: selected);
  }

  Future<void> _onRefresh(
    RefreshMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    _allMovies.clear();
    add(LoadHomeMoviesEvent());
  }

  List<MovieEntity> _filterByCategory(String category) {
    if (category.toLowerCase() == allGenres.toLowerCase()) return _allMovies;
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
