// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentDtoImpl _$$AttachmentDtoImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentDtoImpl(
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$$AttachmentDtoImplToJson(_$AttachmentDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

_$CommentDtoImpl _$$CommentDtoImplFromJson(Map<String, dynamic> json) =>
    _$CommentDtoImpl(
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommentDtoImplToJson(_$CommentDtoImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$CardDtoImpl _$$CardDtoImplFromJson(Map<String, dynamic> json) =>
    _$CardDtoImpl(
      id: json['id'] as String,
      listId: json['listId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      assignee: json['assignee'] as String?,
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      position: (json['position'] as num?)?.toInt(),
      priority: (json['priority'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CardDtoImplToJson(_$CardDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listId': instance.listId,
      'title': instance.title,
      'description': instance.description,
      'assignee': instance.assignee,
      'labels': instance.labels,
      'deadline': instance.deadline?.toIso8601String(),
      'attachments': instance.attachments,
      'comments': instance.comments,
      'position': instance.position,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
    };
