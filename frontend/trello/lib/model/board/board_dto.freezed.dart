// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoardMemberDto _$BoardMemberDtoFromJson(Map<String, dynamic> json) {
  return _BoardMemberDto.fromJson(json);
}

/// @nodoc
mixin _$BoardMemberDto {
  String get userId => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;

  /// Serializes this BoardMemberDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoardMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardMemberDtoCopyWith<BoardMemberDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardMemberDtoCopyWith<$Res> {
  factory $BoardMemberDtoCopyWith(
          BoardMemberDto value, $Res Function(BoardMemberDto) then) =
      _$BoardMemberDtoCopyWithImpl<$Res, BoardMemberDto>;
  @useResult
  $Res call({String userId, String? role});
}

/// @nodoc
class _$BoardMemberDtoCopyWithImpl<$Res, $Val extends BoardMemberDto>
    implements $BoardMemberDtoCopyWith<$Res> {
  _$BoardMemberDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoardMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardMemberDtoImplCopyWith<$Res>
    implements $BoardMemberDtoCopyWith<$Res> {
  factory _$$BoardMemberDtoImplCopyWith(_$BoardMemberDtoImpl value,
          $Res Function(_$BoardMemberDtoImpl) then) =
      __$$BoardMemberDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String? role});
}

/// @nodoc
class __$$BoardMemberDtoImplCopyWithImpl<$Res>
    extends _$BoardMemberDtoCopyWithImpl<$Res, _$BoardMemberDtoImpl>
    implements _$$BoardMemberDtoImplCopyWith<$Res> {
  __$$BoardMemberDtoImplCopyWithImpl(
      _$BoardMemberDtoImpl _value, $Res Function(_$BoardMemberDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BoardMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? role = freezed,
  }) {
    return _then(_$BoardMemberDtoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardMemberDtoImpl implements _BoardMemberDto {
  const _$BoardMemberDtoImpl({required this.userId, this.role});

  factory _$BoardMemberDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardMemberDtoImplFromJson(json);

  @override
  final String userId;
  @override
  final String? role;

  @override
  String toString() {
    return 'BoardMemberDto(userId: $userId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardMemberDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, role);

  /// Create a copy of BoardMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardMemberDtoImplCopyWith<_$BoardMemberDtoImpl> get copyWith =>
      __$$BoardMemberDtoImplCopyWithImpl<_$BoardMemberDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardMemberDtoImplToJson(
      this,
    );
  }
}

abstract class _BoardMemberDto implements BoardMemberDto {
  const factory _BoardMemberDto(
      {required final String userId,
      final String? role}) = _$BoardMemberDtoImpl;

  factory _BoardMemberDto.fromJson(Map<String, dynamic> json) =
      _$BoardMemberDtoImpl.fromJson;

  @override
  String get userId;
  @override
  String? get role;

  /// Create a copy of BoardMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardMemberDtoImplCopyWith<_$BoardMemberDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BoardDto _$BoardDtoFromJson(Map<String, dynamic> json) {
  return _BoardDto.fromJson(json);
}

/// @nodoc
mixin _$BoardDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  List<BoardMemberDto>? get members => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BoardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardDtoCopyWith<BoardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardDtoCopyWith<$Res> {
  factory $BoardDtoCopyWith(BoardDto value, $Res Function(BoardDto) then) =
      _$BoardDtoCopyWithImpl<$Res, BoardDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String ownerId,
      List<BoardMemberDto>? members,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BoardDtoCopyWithImpl<$Res, $Val extends BoardDto>
    implements $BoardDtoCopyWith<$Res> {
  _$BoardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? members = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<BoardMemberDto>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardDtoImplCopyWith<$Res>
    implements $BoardDtoCopyWith<$Res> {
  factory _$$BoardDtoImplCopyWith(
          _$BoardDtoImpl value, $Res Function(_$BoardDtoImpl) then) =
      __$$BoardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String ownerId,
      List<BoardMemberDto>? members,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BoardDtoImplCopyWithImpl<$Res>
    extends _$BoardDtoCopyWithImpl<$Res, _$BoardDtoImpl>
    implements _$$BoardDtoImplCopyWith<$Res> {
  __$$BoardDtoImplCopyWithImpl(
      _$BoardDtoImpl _value, $Res Function(_$BoardDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BoardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? members = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BoardDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<BoardMemberDto>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardDtoImpl implements _BoardDto {
  const _$BoardDtoImpl(
      {required this.id,
      required this.title,
      this.description,
      required this.ownerId,
      final List<BoardMemberDto>? members,
      this.createdAt,
      this.updatedAt})
      : _members = members;

  factory _$BoardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String ownerId;
  final List<BoardMemberDto>? _members;
  @override
  List<BoardMemberDto>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BoardDto(id: $id, title: $title, description: $description, ownerId: $ownerId, members: $members, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, ownerId,
      const DeepCollectionEquality().hash(_members), createdAt, updatedAt);

  /// Create a copy of BoardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardDtoImplCopyWith<_$BoardDtoImpl> get copyWith =>
      __$$BoardDtoImplCopyWithImpl<_$BoardDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardDtoImplToJson(
      this,
    );
  }
}

abstract class _BoardDto implements BoardDto {
  const factory _BoardDto(
      {required final String id,
      required final String title,
      final String? description,
      required final String ownerId,
      final List<BoardMemberDto>? members,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BoardDtoImpl;

  factory _BoardDto.fromJson(Map<String, dynamic> json) =
      _$BoardDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get ownerId;
  @override
  List<BoardMemberDto>? get members;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of BoardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardDtoImplCopyWith<_$BoardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
