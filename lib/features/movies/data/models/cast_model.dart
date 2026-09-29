import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/cast_entity.dart';

part 'cast_model.g.dart';

@JsonSerializable()
class CastModel {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'character_name')
  final String? characterName;
  @JsonKey(name: 'url_small_image')
  final String? urlSmallImage;
  @JsonKey(name: 'imdb_code')
  final String? imdbCode;

  const CastModel({
    this.name,
    this.characterName,
    this.urlSmallImage,
    this.imdbCode,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) =>
      _$CastModelFromJson(json);

  Map<String, dynamic> toJson() => _$CastModelToJson(this);

  CastEntity toEntity() => CastEntity(
    name: name,
    characterName: characterName,
    imageUrl: urlSmallImage,
    imdbCode: imdbCode,
  );
}
