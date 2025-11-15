// lib/models/dto/board_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_dto.freezed.dart';
part 'board_dto.g.dart';

@freezed
class BoardMemberDto with _$BoardMemberDto {
  const factory BoardMemberDto({
    required String userId,
    String? role,
  }) = _BoardMemberDto;

  factory BoardMemberDto.fromJson(Map<String, dynamic> json) => _$BoardMemberDtoFromJson(json);
}

@freezed
class BoardDto with _$BoardDto {
  const factory BoardDto({
    required String id,
    required String title,
    String? description,
    required String ownerId,
    List<BoardMemberDto>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BoardDto;

  factory BoardDto.fromJson(Map<String, dynamic> json) => _$BoardDtoFromJson(json);
}