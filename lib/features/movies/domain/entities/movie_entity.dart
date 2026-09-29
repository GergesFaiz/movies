import 'cast_entity.dart';

class MovieEntity {
  final int? id;
  final String? url;
  final String? imdbCode;
  final String? title;
  final String? titleEnglish;
  final String? titleLong;
  final String? slug;
  final int? year;
  final double? rating;
  final int? runtime;
  final List<String>? genres;
  final String? summary;
  final String? descriptionFull;
  final String? synopsis;
  final String? ytTrailerCode;
  final String? language;
  final String? mpaRating;
  final String? backgroundImage;
  final String? backgroundImageOriginal;
  final String? smallCoverImage;
  final String? mediumCoverImage;
  final String? largeCoverImage;
  final String? state;
  final String? dateUploaded;
  final int? dateUploadedUnix;
  final int? likeCount;
  final int? downloadCount;
  final String? mediumScreenshotImage1;
  final String? mediumScreenshotImage2;
  final String? mediumScreenshotImage3;
  final List<CastEntity>? cast;

  const MovieEntity({
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
    this.cast,
  });

  String get coverImage =>
      mediumCoverImage ?? largeCoverImage ?? smallCoverImage ?? '';

  /// Image for the details header: the backdrop, falling back to the poster.
  String get headerImage {
    final background = backgroundImage;
    if (background != null && background.isNotEmpty) return background;
    return coverImage;
  }

  String get description {
    for (final text in [descriptionFull, summary, synopsis]) {
      if (text != null && text.trim().isNotEmpty) return text.trim();
    }
    return '';
  }

  List<String> get screenshots => [
    mediumScreenshotImage1,
    mediumScreenshotImage2,
    mediumScreenshotImage3,
  ].whereType<String>().where((url) => url.isNotEmpty).toList();

  /// YouTube trailer link, or `null` when the movie has no trailer.
  String? get trailerUrl {
    final code = ytTrailerCode;
    if (code == null || code.trim().isEmpty) return null;
    return 'https://www.youtube.com/watch?v=${code.trim()}';
  }
}
