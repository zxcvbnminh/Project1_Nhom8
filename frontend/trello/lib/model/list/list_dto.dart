// lib/models/dto/list_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_dto.freezed.dart';
part 'list_dto.g.dart';

@freezed
class ListDto with _$ListDto {
  const factory ListDto({
    required String id,
    required String boardId,
    required String title,
    int? position,
    required List<String> cards,
  }) = _ListDto;

  factory ListDto.fromJson(Map<String, dynamic> json) => _$ListDtoFromJson(json);
}