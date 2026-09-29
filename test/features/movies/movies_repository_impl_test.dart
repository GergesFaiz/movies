import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/error/failures.dart';
import 'package:movies/features/movies/data/models/movie_model.dart';
import 'package:movies/features/movies/data/repositories/movies_repository_impl.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeMoviesRemoteDataSource dataSource;
  late MoviesRepositoryImpl repository;

  setUp(() {
    dataSource = FakeMoviesRemoteDataSource()
      ..details = const MovieModel(
        id: 7,
        title: 'Up',
        likeCount: 12,
        runtime: 96,
        rating: 8.3,
        genres: ['Animation'],
      );
    repository = MoviesRepositoryImpl(dataSource);
  });

  test('maps details and drops the movie itself from suggestions', () async {
    dataSource.suggestions = const [
      MovieModel(id: 7, title: 'Up'),
      MovieModel(id: 8, title: 'Coco'),
    ];

    final result = await repository.getMovieDetails(7);
    final details = result.getOrElse(() => throw StateError('expected Right'));

    expect(details.movie.title, 'Up');
    expect(details.likeCount, '12');
    expect(details.runtime, 96);
    expect(details.rating, 8.3);
    expect(details.genres, ['Animation']);
    expect(details.suggestions.map((m) => m.title), ['Coco']);
  });

  test('still returns details when suggestions fail', () async {
    dataSource.suggestionsError = const ServerFailure('boom');

    final result = await repository.getMovieDetails(7);

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(() => throw StateError('expected Right')).suggestions,
      isEmpty,
    );
  });

  test('returns the failure when details fail', () async {
    dataSource.detailsError = const NotFoundFailure('Movie data not found');

    final result = await repository.getMovieDetails(7);

    result.fold(
      (failure) => expect(failure, isA<NotFoundFailure>()),
      (_) => fail('expected Left'),
    );
  });
}
