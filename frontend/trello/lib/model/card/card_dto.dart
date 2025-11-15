// lib/models/dto/card_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_dto.freezed.dart';
part 'card_dto.g.dart';

@freezed
class AttachmentDto with _$AttachmentDto {
  const factory AttachmentDto({
    required String name,
    required String url,
  }) = _AttachmentDto;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) => _$AttachmentDtoFromJson(json);
}

@freezed
class CommentDto with _$CommentDto {
  const factory CommentDto({
    required String userId,
    required String content,
    required DateTime createdAt,
  }) = _CommentDto;

  factory CommentDto.fromJson(Map<String, dynamic> json) => _$CommentDtoFromJson(json);
}

@freezed
class CardDto with _$CardDto {
  const factory CardDto({
    required String id,
    required String listId,
    required String title,
    String? description,
    String? assignee,
    @Default([]) List<String> labels,
    DateTime? deadline,
    @Default([]) List<AttachmentDto> attachments,
    @Default([]) List<CommentDto> comments,
    int? position,
    int? priority,
    required DateTime createdAt,
  }) = _CardDto;

  factory CardDto.fromJson(Map<String, dynamic> json) => _$CardDtoFromJson(json);
}