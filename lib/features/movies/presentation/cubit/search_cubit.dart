import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_movies_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchMoviesUseCase _searchMoviesUseCase;
  Timer? _debounce;

  SearchCubit(this._searchMoviesUseCase) : super(SearchInitial());

  Future<void> search(String rawQuery) async {
    final query = rawQuery.trim();

    _debounce?.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

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

  void clearSearch() {
    _debounce?.cancel();
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
