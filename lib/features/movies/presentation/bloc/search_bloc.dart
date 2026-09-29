import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/search_movies_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const Duration debounceDuration = Duration(milliseconds: 500);

  final SearchMoviesUseCase _searchMoviesUseCase;

  /// The query the user typed last. Older, slower requests compare against
  /// it and drop their results so they can't overwrite newer ones.
  String _latestQuery = '';

  SearchBloc(this._searchMoviesUseCase) : super(SearchInitial()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    _latestQuery = query;

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Debounce: only search once the user stops typing.
    await Future.delayed(debounceDuration);
    if (isClosed || query != _latestQuery) return;

    emit(SearchLoading());

    final result = await _searchMoviesUseCase(query);
    if (isClosed || query != _latestQuery) return;

    result.fold((failure) => emit(SearchError(failure.message)), (movies) {
      if (movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(movies: movies));
      }
    });
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    _latestQuery = '';
    emit(SearchInitial());
  }
}
