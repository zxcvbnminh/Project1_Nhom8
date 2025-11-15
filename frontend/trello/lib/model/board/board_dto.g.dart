// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoardMemberDtoImpl _$$BoardMemberDtoImplFromJson(Map<String, dynamic> json) =>
    _$BoardMemberDtoImpl(
      userId: json['userId'] as String,
      role: json['role'] as String?,
    );

Map<String, dynamic> _$$BoardMemberDtoImplToJson(
        _$BoardMemberDtoImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'role': instance.role,
    };

_$BoardDtoImpl _$$BoardDtoImplFromJson(Map<String, dynamic> json) =>
    _$BoardDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      ownerId: json['ownerId'] as String,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => BoardMemberDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BoardDtoImplToJson(_$BoardDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'ownerId': instance.ownerId,
      'members': instance.members,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
