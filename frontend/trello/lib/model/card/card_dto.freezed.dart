// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) {
  return _AttachmentDto.fromJson(json);
}

/// @nodoc
mixin _$AttachmentDto {
  String get name => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  /// Serializes this AttachmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachmentDtoCopyWith<AttachmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentDtoCopyWith<$Res> {
  factory $AttachmentDtoCopyWith(
          AttachmentDto value, $Res Function(AttachmentDto) then) =
      _$AttachmentDtoCopyWithImpl<$Res, AttachmentDto>;
  @useResult
  $Res call({String name, String url});
}

/// @nodoc
class _$AttachmentDtoCopyWithImpl<$Res, $Val extends AttachmentDto>
    implements $AttachmentDtoCopyWith<$Res> {
  _$AttachmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentDtoImplCopyWith<$Res>
    implements $AttachmentDtoCopyWith<$Res> {
  factory _$$AttachmentDtoImplCopyWith(
          _$AttachmentDtoImpl value, $Res Function(_$AttachmentDtoImpl) then) =
      __$$AttachmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String url});
}

/// @nodoc
class __$$AttachmentDtoImplCopyWithImpl<$Res>
    extends _$AttachmentDtoCopyWithImpl<$Res, _$AttachmentDtoImpl>
    implements _$$AttachmentDtoImplCopyWith<$Res> {
  __$$AttachmentDtoImplCopyWithImpl(
      _$AttachmentDtoImpl _value, $Res Function(_$AttachmentDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? url = null,
  }) {
    return _then(_$AttachmentDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentDtoImpl implements _AttachmentDto {
  const _$AttachmentDtoImpl({required this.name, required this.url});

  factory _$AttachmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String url;

  @override
  String toString() {
    return 'AttachmentDto(name: $name, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url);

  /// Create a copy of AttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentDtoImplCopyWith<_$AttachmentDtoImpl> get copyWith =>
      __$$AttachmentDtoImplCopyWithImpl<_$AttachmentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentDtoImplToJson(
      this,
    );
  }
}

abstract class _AttachmentDto implements AttachmentDto {
  const factory _AttachmentDto(
      {required final String name,
      required final String url}) = _$AttachmentDtoImpl;

  factory _AttachmentDto.fromJson(Map<String, dynamic> json) =
      _$AttachmentDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get url;

  /// Create a copy of AttachmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachmentDtoImplCopyWith<_$AttachmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) {
  return _CommentDto.fromJson(json);
}

/// @nodoc
mixin _$CommentDto {
  String get userId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentDtoCopyWith<CommentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentDtoCopyWith<$Res> {
  factory $CommentDtoCopyWith(
          CommentDto value, $Res Function(CommentDto) then) =
      _$CommentDtoCopyWithImpl<$Res, CommentDto>;
  @useResult
  $Res call({String userId, String content, DateTime createdAt});
}

/// @nodoc
class _$CommentDtoCopyWithImpl<$Res, $Val extends CommentDto>
    implements $CommentDtoCopyWith<$Res> {
  _$CommentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentDtoImplCopyWith<$Res>
    implements $CommentDtoCopyWith<$Res> {
  factory _$$CommentDtoImplCopyWith(
          _$CommentDtoImpl value, $Res Function(_$CommentDtoImpl) then) =
      __$$CommentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String content, DateTime createdAt});
}

/// @nodoc
class __$$CommentDtoImplCopyWithImpl<$Res>
    extends _$CommentDtoCopyWithImpl<$Res, _$CommentDtoImpl>
    implements _$$CommentDtoImplCopyWith<$Res> {
  __$$CommentDtoImplCopyWithImpl(
      _$CommentDtoImpl _value, $Res Function(_$CommentDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_$CommentDtoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentDtoImpl implements _CommentDto {
  const _$CommentDtoImpl(
      {required this.userId, required this.content, required this.createdAt});

  factory _$CommentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentDtoImplFromJson(json);

  @override
  final String userId;
  @override
  final String content;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CommentDto(userId: $userId, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentDtoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, content, createdAt);

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentDtoImplCopyWith<_$CommentDtoImpl> get copyWith =>
      __$$CommentDtoImplCopyWithImpl<_$CommentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentDtoImplToJson(
      this,
    );
  }
}

abstract class _CommentDto implements CommentDto {
  const factory _CommentDto(
      {required final String userId,
      required final String content,
      required final DateTime createdAt}) = _$CommentDtoImpl;

  factory _CommentDto.fromJson(Map<String, dynamic> json) =
      _$CommentDtoImpl.fromJson;

  @override
  String get userId;
  @override
  String get content;
  @override
  DateTime get createdAt;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentDtoImplCopyWith<_$CommentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CardDto _$CardDtoFromJson(Map<String, dynamic> json) {
  return _CardDto.fromJson(json);
}

/// @nodoc
mixin _$CardDto {
  String get id => throw _privateConstructorUsedError;
  String get listId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get assignee => throw _privateConstructorUsedError;
  List<String> get labels => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  List<AttachmentDto> get attachments => throw _privateConstructorUsedError;
  List<CommentDto> get comments => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  int? get priority => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardDtoCopyWith<CardDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardDtoCopyWith<$Res> {
  factory $CardDtoCopyWith(CardDto value, $Res Function(CardDto) then) =
      _$CardDtoCopyWithImpl<$Res, CardDto>;
  @useResult
  $Res call(
      {String id,
      String listId,
      String title,
      String? description,
      String? assignee,
      List<String> labels,
      DateTime? deadline,
      List<AttachmentDto> attachments,
      List<CommentDto> comments,
      int? position,
      int? priority,
      DateTime createdAt});
}

/// @nodoc
class _$CardDtoCopyWithImpl<$Res, $Val extends CardDto>
    implements $CardDtoCopyWith<$Res> {
  _$CardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? title = null,
    Object? description = freezed,
    Object? assignee = freezed,
    Object? labels = null,
    Object? deadline = freezed,
    Object? attachments = null,
    Object? comments = null,
    Object? position = freezed,
    Object? priority = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      assignee: freezed == assignee
          ? _value.assignee
          : assignee // ignore: cast_nullable_to_non_nullable
              as String?,
      labels: null == labels
          ? _value.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentDto>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentDto>,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardDtoImplCopyWith<$Res> implements $CardDtoCopyWith<$Res> {
  factory _$$CardDtoImplCopyWith(
          _$CardDtoImpl value, $Res Function(_$CardDtoImpl) then) =
      __$$CardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String listId,
      String title,
      String? description,
      String? assignee,
      List<String> labels,
      DateTime? deadline,
      List<AttachmentDto> attachments,
      List<CommentDto> comments,
      int? position,
      int? priority,
      DateTime createdAt});
}

/// @nodoc
class __$$CardDtoImplCopyWithImpl<$Res>
    extends _$CardDtoCopyWithImpl<$Res, _$CardDtoImpl>
    implements _$$CardDtoImplCopyWith<$Res> {
  __$$CardDtoImplCopyWithImpl(
      _$CardDtoImpl _value, $Res Function(_$CardDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? listId = null,
    Object? title = null,
    Object? description = freezed,
    Object? assignee = freezed,
    Object? labels = null,
    Object? deadline = freezed,
    Object? attachments = null,
    Object? comments = null,
    Object? position = freezed,
    Object? priority = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CardDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      listId: null == listId
          ? _value.listId
          : listId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      assignee: freezed == assignee
          ? _value.assignee
          : assignee // ignore: cast_nullable_to_non_nullable
              as String?,
      labels: null == labels
          ? _value._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<AttachmentDto>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CommentDto>,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardDtoImpl implements _CardDto {
  const _$CardDtoImpl(
      {required this.id,
      required this.listId,
      required this.title,
      this.description,
      this.assignee,
      final List<String> labels = const [],
      this.deadline,
      final List<AttachmentDto> attachments = const [],
      final List<CommentDto> comments = const [],
      this.position,
      this.priority,
      required this.createdAt})
      : _labels = labels,
        _attachments = attachments,
        _comments = comments;

  factory _$CardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String listId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? assignee;
  final List<String> _labels;
  @override
  @JsonKey()
  List<String> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  final DateTime? deadline;
  final List<AttachmentDto> _attachments;
  @override
  @JsonKey()
  List<AttachmentDto> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<CommentDto> _comments;
  @override
  @JsonKey()
  List<CommentDto> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final int? position;
  @override
  final int? priority;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CardDto(id: $id, listId: $listId, title: $title, description: $description, assignee: $assignee, labels: $labels, deadline: $deadline, attachments: $attachments, comments: $comments, position: $position, priority: $priority, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.listId, listId) || other.listId == listId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.assignee, assignee) ||
                other.assignee == assignee) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      listId,
      title,
      description,
      assignee,
      const DeepCollectionEquality().hash(_labels),
      deadline,
      const DeepCollectionEquality().hash(_attachments),
      const DeepCollectionEquality().hash(_comments),
      position,
      priority,
      createdAt);

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardDtoImplCopyWith<_$CardDtoImpl> get copyWith =>
      __$$CardDtoImplCopyWithImpl<_$CardDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardDtoImplToJson(
      this,
    );
  }
}

abstract class _CardDto implements CardDto {
  const factory _CardDto(
      {required final String id,
      required final String listId,
      required final String title,
      final String? description,
      final String? assignee,
      final List<String> labels,
      final DateTime? deadline,
      final List<AttachmentDto> attachments,
      final List<CommentDto> comments,
      final int? position,
      final int? priority,
      required final DateTime createdAt}) = _$CardDtoImpl;

  factory _CardDto.fromJson(Map<String, dynamic> json) = _$CardDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get listId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get assignee;
  @override
  List<String> get labels;
  @override
  DateTime? get deadline;
  @override
  List<AttachmentDto> get attachments;
  @override
  List<CommentDto> get comments;
  @override
  int? get position;
  @override
  int? get priority;
  @override
  DateTime get createdAt;

  /// Create a copy of CardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardDtoImplCopyWith<_$CardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
