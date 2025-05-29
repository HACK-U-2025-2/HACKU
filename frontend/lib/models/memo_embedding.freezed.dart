// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo_embedding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoEmbedding {

@MemoIdJsonConverter() MemoId get id; String get title; List<double> get simpleEmbedding;
/// Create a copy of MemoEmbedding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoEmbeddingCopyWith<MemoEmbedding> get copyWith => _$MemoEmbeddingCopyWithImpl<MemoEmbedding>(this as MemoEmbedding, _$identity);

  /// Serializes this MemoEmbedding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoEmbedding&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.simpleEmbedding, simpleEmbedding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(simpleEmbedding));

@override
String toString() {
  return 'MemoEmbedding(id: $id, title: $title, simpleEmbedding: $simpleEmbedding)';
}


}

/// @nodoc
abstract mixin class $MemoEmbeddingCopyWith<$Res>  {
  factory $MemoEmbeddingCopyWith(MemoEmbedding value, $Res Function(MemoEmbedding) _then) = _$MemoEmbeddingCopyWithImpl;
@useResult
$Res call({
@MemoIdJsonConverter() MemoId id, String title, List<double> simpleEmbedding
});




}
/// @nodoc
class _$MemoEmbeddingCopyWithImpl<$Res>
    implements $MemoEmbeddingCopyWith<$Res> {
  _$MemoEmbeddingCopyWithImpl(this._self, this._then);

  final MemoEmbedding _self;
  final $Res Function(MemoEmbedding) _then;

/// Create a copy of MemoEmbedding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? simpleEmbedding = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as MemoId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,simpleEmbedding: null == simpleEmbedding ? _self.simpleEmbedding : simpleEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}

}


/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MemoEmbedding implements MemoEmbedding {
  const _MemoEmbedding({@MemoIdJsonConverter() required this.id, required this.title, required final  List<double> simpleEmbedding}): _simpleEmbedding = simpleEmbedding;
  factory _MemoEmbedding.fromJson(Map<String, dynamic> json) => _$MemoEmbeddingFromJson(json);

@override@MemoIdJsonConverter() final  MemoId id;
@override final  String title;
 final  List<double> _simpleEmbedding;
@override List<double> get simpleEmbedding {
  if (_simpleEmbedding is EqualUnmodifiableListView) return _simpleEmbedding;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_simpleEmbedding);
}


/// Create a copy of MemoEmbedding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoEmbeddingCopyWith<_MemoEmbedding> get copyWith => __$MemoEmbeddingCopyWithImpl<_MemoEmbedding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoEmbeddingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoEmbedding&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._simpleEmbedding, _simpleEmbedding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_simpleEmbedding));

@override
String toString() {
  return 'MemoEmbedding(id: $id, title: $title, simpleEmbedding: $simpleEmbedding)';
}


}

/// @nodoc
abstract mixin class _$MemoEmbeddingCopyWith<$Res> implements $MemoEmbeddingCopyWith<$Res> {
  factory _$MemoEmbeddingCopyWith(_MemoEmbedding value, $Res Function(_MemoEmbedding) _then) = __$MemoEmbeddingCopyWithImpl;
@override @useResult
$Res call({
@MemoIdJsonConverter() MemoId id, String title, List<double> simpleEmbedding
});




}
/// @nodoc
class __$MemoEmbeddingCopyWithImpl<$Res>
    implements _$MemoEmbeddingCopyWith<$Res> {
  __$MemoEmbeddingCopyWithImpl(this._self, this._then);

  final _MemoEmbedding _self;
  final $Res Function(_MemoEmbedding) _then;

/// Create a copy of MemoEmbedding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? simpleEmbedding = null,}) {
  return _then(_MemoEmbedding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as MemoId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,simpleEmbedding: null == simpleEmbedding ? _self._simpleEmbedding : simpleEmbedding // ignore: cast_nullable_to_non_nullable
as List<double>,
  ));
}


}

// dart format on
