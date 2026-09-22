import 'package:flutter_test/flutter_test.dart';
import 'package:movies/features/movies/data/remote/models/movie_model.dart';
import 'package:movies/features/movies/data/remote/models/source_response_model.dart';

void main() {
  group('MovieModel.fromJson', () {
    final Map<String, dynamic> json = {
      'id': 1,
      'url': 'https://yts.mx/movies/inception-2010',
      'imdb_code': 'tt1375666',
      'title': 'Inception',
      'title_english': 'Inception',
      'title_long': 'Inception (2010)',
      'slug': 'inception-2010',
      'year': 2010,
      'rating': 8.8,
      'runtime': 148,
      'genres': ['Action', 'Sci-Fi'],
      'summary': 'A thief who steals corporate secrets.',
      'description_full': 'Cobb is the best at extracting secrets.',
      'synopsis': 'Cobb and Arthur are extractors.',
      'language': 'English',
      'mpa_rating': 'PG-13',
      'background_image': 'https://example.com/bg.jpg',
      'small_cover_image': 'https://example.com/small.jpg',
      'medium_cover_image': 'https://example.com/medium.jpg',
      'large_cover_image': 'https://example.com/large.jpg',
      'state': 'ok',
      'date_uploaded': '2020-01-01 00:00:00',
      'date_uploaded_unix': 1577836800,
      'like_count': 100,
      'download_count': 50,
    };

    test('maps all fields correctly', () {
      final movie = MovieModel.fromJson(json);
      expect(movie.id, 1);
      expect(movie.imdbCode, 'tt1375666');
      expect(movie.title, 'Inception');
      expect(movie.year, 2010);
      expect(movie.rating, 8.8);
      expect(movie.runtime, 148);
      expect(movie.genres, ['Action', 'Sci-Fi']);
      expect(movie.dateUploaded, '2020-01-01 00:00:00');
      expect(movie.dateUploadedUnix, 1577836800);
      expect(movie.likeCount, 100);
      expect(movie.downloadCount, 50);
    });

    test('coverImage prefers medium, then large, then small', () {
      final movie = MovieModel.fromJson(json);
      expect(movie.coverImage, 'https://example.com/medium.jpg');

      final noMedium = MovieModel.fromJson(
        {...json, 'medium_cover_image': null},
      );
      expect(noMedium.coverImage, 'https://example.com/large.jpg');

      final noLarge = MovieModel.fromJson({...json, 'large_cover_image': null});
      expect(noLarge.coverImage, 'https://example.com/medium.jpg');
    });

    test('handles missing optional fields', () {
      final movie = MovieModel.fromJson({'title': 'Solo'});
      expect(movie.year, isNull);
      expect(movie.rating, isNull);
      expect(movie.genres, isNull);
      expect(movie.coverImage, isEmpty);
    });

    test('toJson round-trips a parsed movie', () {
      final movie = MovieModel.fromJson(json);
      final roundTrip = MovieModel.fromJson(movie.toJson());
      expect(roundTrip.id, movie.id);
      expect(roundTrip.title, movie.title);
      expect(roundTrip.year, movie.year);
      expect(roundTrip.rating, movie.rating);
      expect(roundTrip.runtime, movie.runtime);
      expect(roundTrip.genres, movie.genres);
      expect(roundTrip.coverImage, 'https://example.com/medium.jpg');
    });
  });

  group('SourceResponseModel', () {
    test('parses a wrapped list of movies', () {
      final Map<String, dynamic> json = {
        'status': 'ok',
        'status_message': 'Query was successful',
        'data': {
          'movie_count': 2,
          'limit': 20,
          'page_number': 1,
          'movies': [
            {'id': 1, 'title': 'The Dark Knight', 'year': 2008, 'rating': 9.0},
            {'id': 2, 'title': 'Interstellar', 'year': 2014, 'rating': 8.6},
          ],
        },
      };

      final response = SourceResponseModel.fromJson(json);
      expect(response.status, 'ok');
      expect(response.statusMessage, 'Query was successful');
      expect(response.data, isNotNull);
      expect(response.data?.movieCount, 2);
      expect(response.data?.limit, 20);
      expect(response.data?.pageNumber, 1);
      expect(response.data?.movies, hasLength(2));
      expect(response.data?.movies?.first.title, 'The Dark Knight');
      expect(response.data?.movies?.last.rating, 8.6);
    });

    test('handles a response without data', () {
      final response = SourceResponseModel.fromJson(
        {'status': 'error', 'status_message': 'No results'},
      );
      expect(response.status, 'error');
      expect(response.data, isNull);
    });
  });
}