import 'package:json_annotation/json_annotation.dart';
import 'package:movies/api/model/movies.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: "movie_count")
  final int? movieCount;
  @JsonKey(name: "limit")
  final int? limit;
  @JsonKey(name: "page_number")
  final int? pageNumber;

  // نستثنيها من الـ generator ونعملها يدوي
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Movies>? movies;

  Data({this.movieCount, this.limit, this.pageNumber, this.movies});

  factory Data.fromJson(Map<String, dynamic> json) {
    final base = _$DataFromJson(json);
    return Data(
      movieCount: base.movieCount,
      limit: base.limit,
      pageNumber: base.pageNumber,
      movies: (json['movies'] as List<dynamic>?)
          ?.map((e) => Movies.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = _$DataToJson(this);
    if (movies != null) {
      map['movies'] = movies!.map((e) => e.toJson()).toList();
    }
    return map;
  }
}
