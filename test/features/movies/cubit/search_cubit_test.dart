import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/movies/domain/usecases/search_movies_usecase.dart';
import 'package:movies/features/movies/presentation/cubit/search_cubit.dart';
import 'package:movies/features/movies/presentation/cubit/search_state.dart';

import 'fakes.dart';

void main() {
  late FakeMoviesRepository repo;
  late SearchCubit cubit;

  setUp(() {
    repo = FakeMoviesRepository();
    cubit = SearchCubit(SearchMoviesUseCase(repo));
  });

  tearDown(() => cubit.close());

  test('starts in SearchInitial', () {
    expect(cubit.state, isA<SearchInitial>());
  });

  test('blank query goes back to SearchInitial', () async {
    await cubit.search('   ');
    expect(cubit.state, isA<SearchInitial>());
  });

  test('matching query emits SearchLoaded', () async {
    repo.searchResult = Right([movie(1)]);
    await cubit.search('movie');
    expect(cubit.state, isA<SearchLoaded>());
    expect((cubit.state as SearchLoaded).movies.single.id, 1);
  });

  test('query with no results emits SearchEmpty', () async {
    repo.searchResult = const Right([]);
    await cubit.search('nothing');
    expect(cubit.state, isA<SearchEmpty>());
  });

  test('failed search emits SearchError with the failure message', () async {
    repo.searchResult = const Left(NetworkFailure());
    await cubit.search('movie');
    expect(cubit.state, isA<SearchError>());
    expect((cubit.state as SearchError).message, 'No internet connection');
  });

  test('clearSearch resets to SearchInitial', () async {
    repo.searchResult = Right([movie(1)]);
    await cubit.search('movie');
    cubit.clearSearch();
    expect(cubit.state, isA<SearchInitial>());
  });
}
