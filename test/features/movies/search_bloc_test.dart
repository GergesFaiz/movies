import 'package:flutter_test/flutter_test.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/movies/domain/usecases/search_movies_usecase.dart';
import 'package:movies/features/movies/presentation/bloc/search_bloc.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMoviesRepository repository;
  late SearchBloc bloc;

  setUp(() {
    repository = FakeMoviesRepository();
    bloc = SearchBloc(SearchMoviesUseCase(repository));
  });

  tearDown(() => bloc.close());

  Future<void> waitForDebounce() => Future.delayed(
    SearchBloc.debounceDuration + const Duration(milliseconds: 100),
  );

  test('only searches for the last query typed', () async {
    repository.searchResults['matrix'] = const [
      MovieEntity(id: 1, title: 'The Matrix'),
    ];

    bloc
      ..add(const SearchQueryChangedEvent('m'))
      ..add(const SearchQueryChangedEvent('mat'))
      ..add(const SearchQueryChangedEvent('matrix'));
    await waitForDebounce();

    expect(repository.searchCalls, ['matrix']);
    expect(bloc.state, isA<SearchLoaded>());
    expect((bloc.state as SearchLoaded).movies.single.title, 'The Matrix');
  });

  test('emits empty when nothing matches', () async {
    bloc.add(const SearchQueryChangedEvent('zzzz'));
    await waitForDebounce();

    expect(bloc.state, isA<SearchEmpty>());
  });

  test('clearing the query cancels a pending search', () async {
    bloc
      ..add(const SearchQueryChangedEvent('matrix'))
      ..add(const SearchQueryChangedEvent(''));
    await waitForDebounce();

    expect(repository.searchCalls, isEmpty);
    expect(bloc.state, isA<SearchInitial>());
  });
}
