// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_embedding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoEmbedding _$MemoEmbeddingFromJson(Map<String, dynamic> json) =>
    _MemoEmbedding(
      id: const MemoIdJsonConverter().fromJson((json['id'] as num).toInt()),
      title: json['title'] as String,
      simpleEmbedding:
          (json['simple_embedding'] as List<dynamic>)
              .map((e) => (e as num).toDouble())
              .toList(),
    );

Map<String, dynamic> _$MemoEmbeddingToJson(_MemoEmbedding instance) =>
    <String, dynamic>{
      'id': const MemoIdJsonConverter().toJson(instance.id),
      'title': instance.title,
      'simple_embedding': instance.simpleEmbedding,
    };
