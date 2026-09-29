import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies/features/movies/presentation/bloc/movies_bloc.dart';

import '../../helpers/fakes.dart';

void main() {
  const action = MovieEntity(id: 1, title: 'Heat', genres: ['Action']);
  const drama = MovieEntity(id: 2, title: 'Up', genres: ['Drama']);
  const sciFi = MovieEntity(
    id: 3,
    title: 'Alien',
    genres: ['Sci-Fi', 'Action'],
  );

  late FakeMoviesRepository repository;
  late MoviesBloc bloc;

  setUp(() {
    repository = FakeMoviesRepository()
      ..moviesResult = const Right([action, drama, sciFi]);
    final useCase = GetMoviesUseCase(repository);
    bloc = MoviesBloc(useCase, useCase);
  });

  tearDown(() => bloc.close());

  group('home', () {
    test('loads movies and picks a category that matches its movies', () async {
      bloc.add(LoadHomeMoviesEvent());
      final state =
          await bloc.stream.firstWhere((s) => s is HomeMoviesLoaded)
              as HomeMoviesLoaded;

      expect(state.carouselMovies, [action, drama, sciFi]);
      expect(state.categoryMovies, isNotEmpty);
      for (final movie in state.categoryMovies) {
        expect(movie.genres, contains(state.currentCategory));
      }
    });

    test('keeps the raw genre name so "See More" can reuse it', () async {
      repository.moviesResult = const Right([sciFi]);
      bloc.add(LoadHomeMoviesEvent());
      final state =
          await bloc.stream.firstWhere((s) => s is HomeMoviesLoaded)
              as HomeMoviesLoaded;

      expect(['Sci-Fi', 'Action'], contains(state.currentCategory));
    });

    test('emits an empty loaded state instead of loading forever', () async {
      repository.moviesResult = const Right([]);
      bloc.add(LoadHomeMoviesEvent());
      final state =
          await bloc.stream.firstWhere((s) => s is HomeMoviesLoaded)
              as HomeMoviesLoaded;

      expect(state.carouselMovies, isEmpty);
    });

    test('emits an error when loading fails', () async {
      repository.moviesResult = const Left(NetworkFailure());
      bloc.add(LoadHomeMoviesEvent());

      final state =
          await bloc.stream.firstWhere((s) => s is HomeMoviesError)
              as HomeMoviesError;
      expect(state.message, const NetworkFailure().message);
    });
  });

  group('browse', () {
    test('lists "All" first followed by the sorted genres', () async {
      bloc.add(LoadBrowseMoviesEvent());
      final state =
          await bloc.stream.firstWhere((s) => s is BrowseMoviesLoaded)
              as BrowseMoviesLoaded;

      expect(state.genres, [MoviesBloc.allGenres, 'Action', 'Drama', 'Sci-Fi']);
      expect(state.selectedGenre, MoviesBloc.allGenres);
      expect(state.movies, hasLength(3));
    });

    test('filters by the selected genre', () async {
      bloc.add(LoadBrowseMoviesEvent());
      await bloc.stream.firstWhere((s) => s is BrowseMoviesLoaded);

      bloc.add(const SelectGenreEvent('Action'));
      final state = await bloc.stream.first as BrowseMoviesLoaded;

      expect(state.selectedGenre, 'Action');
      expect(state.movies, [action, sciFi]);
    });

    test('applies a genre chosen before the movies finished loading', () async {
      bloc
        ..add(const SelectGenreEvent('drama'))
        ..add(LoadBrowseMoviesEvent());

      final state =
          await bloc.stream.firstWhere((s) => s is BrowseMoviesLoaded)
              as BrowseMoviesLoaded;

      expect(state.selectedGenre, 'Drama');
      expect(state.movies, [drama]);
    });

    test('falls back to "All" for an unknown genre', () async {
      bloc.add(LoadBrowseMoviesEvent());
      await bloc.stream.firstWhere((s) => s is BrowseMoviesLoaded);

      bloc
        ..add(const SelectGenreEvent('Action'))
        ..add(const SelectGenreEvent('Western'));
      await pumpEventQueue();
      final state = bloc.state as BrowseMoviesLoaded;

      expect(state.selectedGenre, MoviesBloc.allGenres);
      expect(state.movies, hasLength(3));
    });
  });
}
