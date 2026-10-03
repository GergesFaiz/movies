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
}
