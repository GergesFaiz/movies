import 'movie_entity.dart';

class MovieDetailsEntity {
  final String likeCount;
  final int runtime;
  final double rating;
  final List<String> genres;
  final List<String> screenshots;
  final List<dynamic> cast;
  final List<MovieEntity> suggestions;

  const MovieDetailsEntity({
    required this.likeCount,
    required this.runtime,
    required this.rating,
    required this.genres,
    required this.screenshots,
    required this.cast,
    required this.suggestions,
  });
}
