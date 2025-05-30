// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoPreview {

@MemoIdJsonConverter() MemoId get id; String get title; String get body; DateTime get createdAt; DateTime? get updatedAt; bool get isFavorite;
/// Create a copy of MemoPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoPreviewCopyWith<MemoPreview> get copyWith => _$MemoPreviewCopyWithImpl<MemoPreview>(this as MemoPreview, _$identity);

  /// Serializes this MemoPreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,createdAt,updatedAt,isFavorite);

@override
String toString() {
  return 'MemoPreview(id: $id, title: $title, body: $body, createdAt: $createdAt, updatedAt: $updatedAt, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $MemoPreviewCopyWith<$Res>  {
  factory $MemoPreviewCopyWith(MemoPreview value, $Res Function(MemoPreview) _then) = _$MemoPreviewCopyWithImpl;
@useResult
$Res call({
@MemoIdJsonConverter() MemoId id, String title, String body, DateTime createdAt, DateTime? updatedAt, bool isFavorite
});




}
/// @nodoc
class _$MemoPreviewCopyWithImpl<$Res>
    implements $MemoPreviewCopyWith<$Res> {
  _$MemoPreviewCopyWithImpl(this._self, this._then);

  final MemoPreview _self;
  final $Res Function(MemoPreview) _then;

/// Create a copy of MemoPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? body = null,Object? createdAt = null,Object? updatedAt = freezed,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as MemoId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MemoPreview implements MemoPreview {
  const _MemoPreview({@MemoIdJsonConverter() required this.id, required this.title, required this.body, required this.createdAt, this.updatedAt, this.isFavorite = false});
  factory _MemoPreview.fromJson(Map<String, dynamic> json) => _$MemoPreviewFromJson(json);

@override@MemoIdJsonConverter() final  MemoId id;
@override final  String title;
@override final  String body;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of MemoPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoPreviewCopyWith<_MemoPreview> get copyWith => __$MemoPreviewCopyWithImpl<_MemoPreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoPreviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoPreview&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,body,createdAt,updatedAt,isFavorite);

@override
String toString() {
  return 'MemoPreview(id: $id, title: $title, body: $body, createdAt: $createdAt, updatedAt: $updatedAt, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$MemoPreviewCopyWith<$Res> implements $MemoPreviewCopyWith<$Res> {
  factory _$MemoPreviewCopyWith(_MemoPreview value, $Res Function(_MemoPreview) _then) = __$MemoPreviewCopyWithImpl;
@override @useResult
$Res call({
@MemoIdJsonConverter() MemoId id, String title, String body, DateTime createdAt, DateTime? updatedAt, bool isFavorite
});




}
/// @nodoc
class __$MemoPreviewCopyWithImpl<$Res>
    implements _$MemoPreviewCopyWith<$Res> {
  __$MemoPreviewCopyWithImpl(this._self, this._then);

  final _MemoPreview _self;
  final $Res Function(_MemoPreview) _then;

/// Create a copy of MemoPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? body = null,Object? createdAt = null,Object? updatedAt = freezed,Object? isFavorite = null,}) {
  return _then(_MemoPreview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as MemoId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
