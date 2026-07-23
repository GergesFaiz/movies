import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/movie_entity.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'imdb_code')
  final String? imdbCode;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'title_english')
  final String? titleEnglish;
  @JsonKey(name: 'title_long')
  final String? titleLong;
  @JsonKey(name: 'slug')
  final String? slug;
  @JsonKey(name: 'year')
  final int? year;
  @JsonKey(name: 'rating')
  final double? rating;
  @JsonKey(name: 'runtime')
  final int? runtime;
  @JsonKey(name: 'genres')
  final List<String>? genres;
  @JsonKey(name: 'summary')
  final String? summary;
  @JsonKey(name: 'description_full')
  final String? descriptionFull;
  @JsonKey(name: 'synopsis')
  final String? synopsis;
  @JsonKey(name: 'yt_trailer_code')
  final String? ytTrailerCode;
  @JsonKey(name: 'language')
  final String? language;
  @JsonKey(name: 'mpa_rating')
  final String? mpaRating;
  @JsonKey(name: 'background_image')
  final String? backgroundImage;
  @JsonKey(name: 'background_image_original')
  final String? backgroundImageOriginal;
  @JsonKey(name: 'small_cover_image')
  final String? smallCoverImage;
  @JsonKey(name: 'medium_cover_image')
  final String? mediumCoverImage;
  @JsonKey(name: 'large_cover_image')
  final String? largeCoverImage;
  @JsonKey(name: 'state')
  final String? state;
  @JsonKey(name: 'date_uploaded')
  final String? dateUploaded;
  @JsonKey(name: 'date_uploaded_unix')
  final int? dateUploadedUnix;
  @JsonKey(name: 'like_count')
  final int? likeCount;
  @JsonKey(name: 'download_count')
  final int? downloadCount;
  @JsonKey(name: 'medium_screenshot_image1')
  final String? mediumScreenshotImage1;
  @JsonKey(name: 'medium_screenshot_image2')
  final String? mediumScreenshotImage2;
  @JsonKey(name: 'medium_screenshot_image3')
  final String? mediumScreenshotImage3;

  const MovieModel({
    this.id,
    this.url,
    this.imdbCode,
    this.title,
    this.titleEnglish,
    this.titleLong,
    this.slug,
    this.year,
    this.rating,
    this.runtime,
    this.genres,
    this.summary,
    this.descriptionFull,
    this.synopsis,
    this.ytTrailerCode,
    this.language,
    this.mpaRating,
    this.backgroundImage,
    this.backgroundImageOriginal,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.state,
    this.dateUploaded,
    this.dateUploadedUnix,
    this.likeCount,
    this.downloadCount,
    this.mediumScreenshotImage1,
    this.mediumScreenshotImage2,
    this.mediumScreenshotImage3,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  factory MovieModel.fromEntity(MovieEntity movie) => MovieModel(
    id: movie.id,
    title: movie.title,
    rating: movie.rating,
    mediumCoverImage: movie.mediumCoverImage,
    largeCoverImage: movie.largeCoverImage,
    smallCoverImage: movie.smallCoverImage,
  );

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  String get coverImage =>
      mediumCoverImage ?? largeCoverImage ?? smallCoverImage ?? '';

  MovieEntity toEntity() => MovieEntity(
    id: id,
    url: url,
    imdbCode: imdbCode,
    title: title,
    titleEnglish: titleEnglish,
    titleLong: titleLong,
    slug: slug,
    year: year,
    rating: rating,
    runtime: runtime,
    genres: genres,
    summary: summary,
    descriptionFull: descriptionFull,
    synopsis: synopsis,
    ytTrailerCode: ytTrailerCode,
    language: language,
    mpaRating: mpaRating,
    backgroundImage: backgroundImage,
    backgroundImageOriginal: backgroundImageOriginal,
    smallCoverImage: smallCoverImage,
    mediumCoverImage: mediumCoverImage,
    largeCoverImage: largeCoverImage,
    state: state,
    dateUploaded: dateUploaded,
    dateUploadedUnix: dateUploadedUnix,
    likeCount: likeCount,
    downloadCount: downloadCount,
    mediumScreenshotImage1: mediumScreenshotImage1,
    mediumScreenshotImage2: mediumScreenshotImage2,
    mediumScreenshotImage3: mediumScreenshotImage3,
  );
}
