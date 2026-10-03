import 'package:flutter_test/flutter_test.dart';
import 'package:movies/features/movies/domain/usecases/add_to_history_usecase.dart';
import 'package:movies/features/movies/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies/features/movies/domain/usecases/is_movie_in_watchlist_usecase.dart';
import 'package:movies/features/movies/domain/usecases/toggle_watchlist_usecase.dart';
import 'package:movies/features/movies/presentation/cubit/movie_details_cubit.dart';
import 'package:movies/features/movies/presentation/cubit/movie_details_state.dart';

import 'fakes.dart';

void main() {
  late FakeMoviesRepository repo;
  late FakeUserMoviesRepository userRepo;
  late MovieDetailsCubit cubit;

  setUp(() {
    repo = FakeMoviesRepository();
    userRepo = FakeUserMoviesRepository();
    cubit = MovieDetailsCubit(
      GetMovieDetailsUseCase(repo),
      ToggleWatchlistUseCase(userRepo),
      AddToHistoryUseCase(userRepo),
      IsMovieInWatchlistUseCase(userRepo),
    );
  });

  tearDown(() => cubit.close());

  test('starts in MovieDetailsInitial', () {
    expect(cubit.state, isA<MovieDetailsInitial>());
  });

  test('loadMovieDetails emits MovieDetailsError when the fetch fails',
      () async {
    await cubit.loadMovieDetails(7);
    expect(cubit.state, isA<MovieDetailsError>());
  });

  test('toggleWatchlist forwards the movie to the repository', () async {
    await cubit.toggleWatchlist(movie(3));
    expect(userRepo.toggled.single.id, 3);
  });

  test('addToHistory forwards the movie to the repository', () async {
    await cubit.addToHistory(movie(4));
    expect(userRepo.history.single.id, 4);
  });

  test('isMovieInWatchlist exposes the watchlist stream', () async {
    expect(await cubit.isMovieInWatchlist(1).first, false);
  });
}
