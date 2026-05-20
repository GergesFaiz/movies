import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/retrofit_service.dart';

import 'search_state.dart';

class SearchTabViewModel extends Cubit<SearchState> {
  SearchTabViewModel() : super(SearchInitial());

  final RetrofitService apiService = RetrofitService(Dio());
  Timer? debounce;

  void searchMovies(String query) {
    if (query.trim().isEmpty) {
      debounce?.cancel();
      emit(SearchInitial());
      return;
    }

    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());

      try {
        final response = await apiService.getMovies(
          queryTerm: query,
          limit: 50,
        );

        final movies = response.data?.movies ?? [];

        if (movies.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(SearchLoaded(movies: movies));
        }
      } on DioException catch (e) {
        emit(
          SearchError(
            message: e.response?.statusCode == 404
                ? "No movies found"
                : "Network error, please check your connection",
          ),
        );
      } catch (e) {
        emit(SearchError(message: "Something went wrong"));
      }
    });
  }

  @override
  Future<void> close() {
    debounce?.cancel();
    return super.close();
  }
}
