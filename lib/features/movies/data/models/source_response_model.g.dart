// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataModel _$DataModelFromJson(Map<String, dynamic> json) => DataModel(
  movieCount: (json['movie_count'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  pageNumber: (json['page_number'] as num?)?.toInt(),
  movies: (json['movies'] as List<dynamic>?)
      ?.map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
  'movie_count': instance.movieCount,
  'limit': instance.limit,
  'page_number': instance.pageNumber,
  'movies': instance.movies,
};

SourceResponseModel _$SourceResponseModelFromJson(Map<String, dynamic> json) =>
    SourceResponseModel(
      status: json['status'] as String?,
      statusMessage: json['status_message'] as String?,
    );

Map<String, dynamic> _$SourceResponseModelToJson(
  SourceResponseModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'status_message': instance.statusMessage,
};
