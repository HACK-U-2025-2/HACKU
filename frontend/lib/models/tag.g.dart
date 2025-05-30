// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
  id: const TagIdJsonConverter().fromJson((json['id'] as num).toInt()),
  name: json['name'] as String,
  usedNum: (json['used_num'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
  'id': const TagIdJsonConverter().toJson(instance.id),
  'name': instance.name,
  'used_num': instance.usedNum,
};
