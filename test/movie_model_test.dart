import 'package:flutter_test/flutter_test.dart';
import 'package:movies/features/movies/data/models/movie_model.dart';

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

    test('parses movie details with cast into an entity', () {
      final movie = MovieModel.fromJson({
        'id': 10,
        'title': 'Inception',
        'year': 2010,
        'rating': 8.8,
        'runtime': 148,
        'like_count': 42,
        'genres': ['Action', 'Sci-Fi'],
        'description_full': '  A thief who steals corporate secrets.  ',
        'yt_trailer_code': 'YoHD9XEInc0',
        'background_image': 'https://example.com/bg.jpg',
        'medium_cover_image': 'https://example.com/medium.jpg',
        'medium_screenshot_image1': 'https://example.com/1.jpg',
        'medium_screenshot_image2': '',
        'cast': [
          {
            'name': 'Leonardo DiCaprio',
            'character_name': 'Cobb',
            'url_small_image': 'https://example.com/leo.jpg',
            'imdb_code': '0000138',
          },
        ],
      }).toEntity();

      expect(movie.title, 'Inception');
      expect(movie.description, 'A thief who steals corporate secrets.');
      expect(movie.trailerUrl, 'https://www.youtube.com/watch?v=YoHD9XEInc0');
      expect(movie.headerImage, 'https://example.com/bg.jpg');
      expect(movie.screenshots, ['https://example.com/1.jpg']);
      expect(movie.cast, hasLength(1));
      expect(movie.cast!.single.name, 'Leonardo DiCaprio');
      expect(movie.cast!.single.characterName, 'Cobb');
      expect(movie.cast!.single.imageUrl, 'https://example.com/leo.jpg');
    });

    test('has no trailer url without a trailer code', () {
      expect(
        const MovieModel(ytTrailerCode: ' ').toEntity().trailerUrl,
        isNull,
      );
      expect(const MovieModel().toEntity().trailerUrl, isNull);
    });
  });
}
