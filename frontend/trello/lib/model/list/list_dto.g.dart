// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListDtoImpl _$$ListDtoImplFromJson(Map<String, dynamic> json) =>
    _$ListDtoImpl(
      id: json['id'] as String,
      boardId: json['boardId'] as String,
      title: json['title'] as String,
      position: (json['position'] as num?)?.toInt(),
      cards: (json['cards'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ListDtoImplToJson(_$ListDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boardId': instance.boardId,
      'title': instance.title,
      'position': instance.position,
      'cards': instance.cards,
    };
