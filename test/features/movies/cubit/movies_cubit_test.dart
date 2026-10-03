import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies/features/movies/presentation/cubit/movies_cubit.dart';
import 'package:movies/features/movies/presentation/cubit/movies_state.dart';

import 'fakes.dart';

void main() {
  late FakeMoviesRepository repo;
  late MoviesCubit cubit;

  setUp(() {
    repo = FakeMoviesRepository();
    final getMovies = GetMoviesUseCase(repo);
    cubit = MoviesCubit(getMovies, getMovies);
  });

  tearDown(() => cubit.close());

  test('loadHomeMovies emits HomeMoviesLoaded with a carousel', () async {
    repo.moviesResult = Right([
      movie(1, genres: ['Action']),
      movie(2, genres: ['Drama']),
    ]);

    await cubit.loadHomeMovies();

    final state = cubit.state as HomeMoviesLoaded;
    expect(state.carouselMovies.length, 2);
    expect(repo.getMoviesCalls, 1);
  });

  test('loadHomeMovies emits HomeMoviesError on failure', () async {
    repo.moviesResult = const Left(ServerFailure('boom'));

    await cubit.loadHomeMovies();

    expect(cubit.state, isA<HomeMoviesError>());
    expect((cubit.state as HomeMoviesError).message, 'boom');
  });

  test('loadHomeMovies does not refetch once movies are cached', () async {
    repo.moviesResult = Right([movie(1, genres: ['Action'])]);

    await cubit.loadHomeMovies();
    await cubit.loadHomeMovies();

    expect(repo.getMoviesCalls, 1);
  });

  test('loadBrowseMovies builds genres with All first', () async {
    repo.moviesResult = Right([
      movie(1, genres: ['Drama']),
      movie(2, genres: ['Action']),
    ]);

    await cubit.loadBrowseMovies();

    final state = cubit.state as BrowseMoviesLoaded;
    expect(state.genres, ['All', 'Action', 'Drama']);
    expect(state.selectedGenre, 'All');
    expect(state.movies.length, 2);
  });

  test('selectGenre filters browse movies by genre', () async {
    repo.moviesResult = Right([
      movie(1, genres: ['Drama']),
      movie(2, genres: ['Action']),
    ]);
    await cubit.loadBrowseMovies();

    cubit.selectGenre('Action');

    final state = cubit.state as BrowseMoviesLoaded;
    expect(state.selectedGenre, 'Action');
    expect(state.movies.map((m) => m.id), [2]);
  });

  test('selectGenre is ignored when browse is not loaded', () {
    cubit.selectGenre('Action');
    expect(cubit.state, isA<MoviesInitial>());
  });

  test('selectGenre All returns every browse movie', () async {
    repo.moviesResult = Right([
      movie(1, genres: ['Drama']),
      movie(2, genres: ['Action']),
    ]);
    await cubit.loadBrowseMovies();

    cubit.selectGenre('Action');
    cubit.selectGenre('All');

    final state = cubit.state as BrowseMoviesLoaded;
    expect(state.selectedGenre, 'All');
    expect(state.movies.map((m) => m.id), [1, 2]);
  });

  test('loadBrowseMovies emits BrowseMoviesError on failure', () async {
    repo.moviesResult = const Left(ServerFailure('browse failed'));

    await cubit.loadBrowseMovies();

    expect(cubit.state, isA<BrowseMoviesError>());
    expect((cubit.state as BrowseMoviesError).message, 'browse failed');
  });

  test('changeCategory filters home movies by the chosen category', () async {
    repo.moviesResult = Right([
      movie(1, genres: ['Action']),
      movie(2, genres: ['Drama']),
    ]);
    await cubit.loadHomeMovies();

    cubit.changeCategory('Drama');

    final state = cubit.state as HomeMoviesLoaded;
    expect(state.currentCategory, 'Drama');
    expect(state.categoryMovies.map((m) => m.id), [2]);
  });

  test('changeCategory is ignored when home is not loaded', () {
    cubit.changeCategory('Drama');
    expect(cubit.state, isA<MoviesInitial>());
  });

  test('refresh clears the cache and fetches movies again', () async {
    repo.moviesResult = Right([movie(1, genres: ['Action'])]);
    await cubit.loadHomeMovies();

    await cubit.refresh();

    expect(repo.getMoviesCalls, 2);
    expect(cubit.state, isA<HomeMoviesLoaded>());
  });
}
