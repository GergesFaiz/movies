import 'cast_entity.dart';
import 'movie_entity.dart';

class MovieDetailsEntity {
  final MovieEntity movie;
  final List<MovieEntity> suggestions;

  const MovieDetailsEntity({required this.movie, required this.suggestions});

  String get likeCount => (movie.likeCount ?? 0).toString();

  int get runtime => movie.runtime ?? 0;

  double get rating => movie.rating ?? 0;

  List<String> get genres => movie.genres ?? const [];

  List<String> get screenshots => movie.screenshots;

  List<CastEntity> get cast => movie.cast ?? const [];
}
