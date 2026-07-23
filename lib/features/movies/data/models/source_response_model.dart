import 'package:json_annotation/json_annotation.dart';

import 'movie_model.dart';

part 'source_response_model.g.dart';

@JsonSerializable()
class DataModel {
  @JsonKey(name: 'movie_count')
  final int? movieCount;
  @JsonKey(name: 'limit')
  final int? limit;
  @JsonKey(name: 'page_number')
  final int? pageNumber;
  @JsonKey(name: 'movies')
  final List<MovieModel>? movies;

  const DataModel({this.movieCount, this.limit, this.pageNumber, this.movies});

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}

@JsonSerializable()
class SourceResponseModel {
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'status_message')
  final String? statusMessage;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DataModel? data;

  SourceResponseModel({this.status, this.statusMessage, this.data});

  factory SourceResponseModel.fromJson(Map<String, dynamic> json) {
    final base = _$SourceResponseModelFromJson(json);
    return SourceResponseModel(
      status: base.status,
      statusMessage: base.statusMessage,
      data: json['data'] != null
          ? DataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$SourceResponseModelToJson(this);
}
