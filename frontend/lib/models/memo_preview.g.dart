// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoPreview _$MemoPreviewFromJson(Map<String, dynamic> json) => _MemoPreview(
  id: const MemoIdJsonConverter().fromJson((json['id'] as num).toInt()),
  title: json['title'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  isFavorite: json['is_favorite'] as bool? ?? false,
);

Map<String, dynamic> _$MemoPreviewToJson(_MemoPreview instance) =>
    <String, dynamic>{
      'id': const MemoIdJsonConverter().toJson(instance.id),
      'title': instance.title,
      'body': instance.body,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_favorite': instance.isFavorite,
    };
