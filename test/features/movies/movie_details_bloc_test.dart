import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/movies/domain/entities/movie_details_entity.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/movies/domain/usecases/add_to_history_usecase.dart';
import 'package:movies/features/movies/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies/features/movies/domain/usecases/is_movie_in_watchlist_usecase.dart';
import 'package:movies/features/movies/domain/usecases/toggle_watchlist_usecase.dart';
import 'package:movies/features/movies/presentation/bloc/movie_details_bloc.dart';

import '../../helpers/fakes.dart';

void main() {
  const movie = MovieEntity(id: 5, title: 'Heat');

  late FakeMoviesRepository moviesRepository;
  late FakeUserMoviesRepository userMoviesRepository;
  late MovieDetailsBloc bloc;

  setUp(() {
    moviesRepository = FakeMoviesRepository()
      ..detailsResult = const Right(
        MovieDetailsEntity(movie: movie, suggestions: []),
      );
    userMoviesRepository = FakeUserMoviesRepository();
    bloc = MovieDetailsBloc(
      GetMovieDetailsUseCase(moviesRepository),
      ToggleWatchlistUseCase(userMoviesRepository),
      AddToHistoryUseCase(userMoviesRepository),
      IsMovieInWatchlistUseCase(userMoviesRepository),
    );
  });

  tearDown(() async {
    await bloc.close();
    await userMoviesRepository.watchlistStatus.close();
  });

  test('loads the movie details', () async {
    bloc.add(const LoadMovieDetailsEvent(5));

    final state = await bloc.stream.firstWhere(
      (s) => s.status == MovieDetailsStatus.loaded,
    );
    expect(state.details!.movie.title, 'Heat');
  });

  test('reports load failures', () async {
    moviesRepository.detailsResult = const Left(NetworkFailure());
    bloc.add(const LoadMovieDetailsEvent(5));

    final state = await bloc.stream.firstWhere(
      (s) => s.status == MovieDetailsStatus.failure,
    );
    expect(state.errorMessage, const NetworkFailure().message);
  });

  test('follows the watchlist status stream', () async {
    bloc.add(const WatchWatchlistStatusEvent(5));
    await pumpEventQueue();

    userMoviesRepository.watchlistStatus.add(true);
    final state = await bloc.stream.firstWhere((s) => s.isInWatchlist);
    expect(state.isInWatchlist, isTrue);
  });

  test('toggling reports whether the movie was added or removed', () async {
    bloc.add(const ToggleWatchlistEvent(movie));
    var state = await bloc.stream.firstWhere((s) => s.watchlistAction != null);
    expect(state.watchlistAction, WatchlistAction.added);
    expect(state.isInWatchlist, isTrue);

    bloc.add(const ToggleWatchlistEvent(movie));
    state = await bloc.stream.firstWhere(
      (s) => s.watchlistAction == WatchlistAction.removed,
    );
    expect(state.isInWatchlist, isFalse);
  });

  test('toggling surfaces failures (e.g. signed out)', () async {
    userMoviesRepository.toggleResult = const Left(
      AuthFailure('Please sign in to use your watchlist.'),
    );
    bloc.add(const ToggleWatchlistEvent(movie));

    final state = await bloc.stream.firstWhere((s) => s.watchlistError != null);
    expect(state.watchlistError, 'Please sign in to use your watchlist.');
    expect(state.isTogglingWatchlist, isFalse);
  });

  test('records the movie in the history', () async {
    bloc.add(const AddToHistoryEvent(movie));
    await pumpEventQueue();

    expect(userMoviesRepository.history, [movie]);
  });
}
