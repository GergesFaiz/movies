import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_movies_usecase.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMoviesUseCase _getMoviesUseCase;
  final GetMoviesUseCase _getBrowseMoviesUseCase;

  List<MovieEntity> _allMovies = [];

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

  void _onSelectGenre(SelectGenreEvent event, Emitter<MoviesState> emit) {
    if (state is! BrowseMoviesLoaded) return;
    final current = state as BrowseMoviesLoaded;
    final filtered = event.genre == 'All'
        ? current.allMovies
        : current.allMovies
              .where((m) => m.genres?.contains(event.genre) ?? false)
              .toList();

    emit(current.copyWith(movies: filtered, selectedGenre: event.genre));
  }

  Future<void> _onRefresh(
    RefreshMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    _allMovies.clear();
    add(LoadHomeMoviesEvent());
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
