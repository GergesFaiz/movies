import 'package:flutter_test/flutter_test.dart';
import 'package:movies/features/movies/data/remote/models/movie_model.dart';

void main() {
  group('MovieModel', () {
    test('uses the first available cover image', () {
      const movie = MovieModel(
        largeCoverImage: 'https://example.com/large.jpg',
        smallCoverImage: 'https://example.com/small.jpg',
      );

      expect(movie.coverImage, 'https://example.com/large.jpg');
    });

    test('returns an empty string when no cover image exists', () {
      const movie = MovieModel();

      expect(movie.coverImage, isEmpty);
    });
  });
}
