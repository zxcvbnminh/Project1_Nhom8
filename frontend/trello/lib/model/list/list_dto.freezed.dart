// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ListDto _$ListDtoFromJson(Map<String, dynamic> json) {
  return _ListDto.fromJson(json);
}

/// @nodoc
mixin _$ListDto {
  String get id => throw _privateConstructorUsedError;
  String get boardId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  List<String> get cards => throw _privateConstructorUsedError;

  /// Serializes this ListDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ListDtoCopyWith<ListDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListDtoCopyWith<$Res> {
  factory $ListDtoCopyWith(ListDto value, $Res Function(ListDto) then) =
      _$ListDtoCopyWithImpl<$Res, ListDto>;
  @useResult
  $Res call(
      {String id,
      String boardId,
      String title,
      int? position,
      List<String> cards});
}

/// @nodoc
class _$ListDtoCopyWithImpl<$Res, $Val extends ListDto>
    implements $ListDtoCopyWith<$Res> {
  _$ListDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boardId = null,
    Object? title = null,
    Object? position = freezed,
    Object? cards = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      cards: null == cards
          ? _value.cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListDtoImplCopyWith<$Res> implements $ListDtoCopyWith<$Res> {
  factory _$$ListDtoImplCopyWith(
          _$ListDtoImpl value, $Res Function(_$ListDtoImpl) then) =
      __$$ListDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String boardId,
      String title,
      int? position,
      List<String> cards});
}

/// @nodoc
class __$$ListDtoImplCopyWithImpl<$Res>
    extends _$ListDtoCopyWithImpl<$Res, _$ListDtoImpl>
    implements _$$ListDtoImplCopyWith<$Res> {
  __$$ListDtoImplCopyWithImpl(
      _$ListDtoImpl _value, $Res Function(_$ListDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ListDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boardId = null,
    Object? title = null,
    Object? position = freezed,
    Object? cards = null,
  }) {
    return _then(_$ListDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      boardId: null == boardId
          ? _value.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      cards: null == cards
          ? _value._cards
          : cards // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListDtoImpl implements _ListDto {
  const _$ListDtoImpl(
      {required this.id,
      required this.boardId,
      required this.title,
      this.position,
      required final List<String> cards})
      : _cards = cards;

  factory _$ListDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String boardId;
  @override
  final String title;
  @override
  final int? position;
  final List<String> _cards;
  @override
  List<String> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'ListDto(id: $id, boardId: $boardId, title: $title, position: $position, cards: $cards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.position, position) ||
                other.position == position) &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, boardId, title, position,
      const DeepCollectionEquality().hash(_cards));

  /// Create a copy of ListDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ListDtoImplCopyWith<_$ListDtoImpl> get copyWith =>
      __$$ListDtoImplCopyWithImpl<_$ListDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListDtoImplToJson(
      this,
    );
  }
}

abstract class _ListDto implements ListDto {
  const factory _ListDto(
      {required final String id,
      required final String boardId,
      required final String title,
      final int? position,
      required final List<String> cards}) = _$ListDtoImpl;

  factory _ListDto.fromJson(Map<String, dynamic> json) = _$ListDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get boardId;
  @override
  String get title;
  @override
  int? get position;
  @override
  List<String> get cards;

  /// Create a copy of ListDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ListDtoImplCopyWith<_$ListDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
