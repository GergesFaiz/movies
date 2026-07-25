import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/search_movies_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMoviesUseCase _searchMoviesUseCase;
  Timer? _debounce;

  SearchBloc(this._searchMoviesUseCase) : super(SearchInitial()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      _debounce?.cancel();
      emit(SearchInitial());
      return;
    }

    _debounce?.cancel();

    // Debounce 500ms
    await Future.delayed(const Duration(milliseconds: 500));
    if (isClosed) return;

    emit(SearchLoading());

    final result = await _searchMoviesUseCase(query);

    result.fold((failure) => emit(SearchError(failure.message)), (movies) {
      if (movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(movies: movies));
      }
    });
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<SearchState> emit) {
    _debounce?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
