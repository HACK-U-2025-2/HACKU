// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMemosQuery _$GetMemosQueryFromJson(Map<String, dynamic> json) =>
    GetMemosQuery(
      keyword: json['keyword'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sort: $enumDecodeNullable(_$MemoSortEnumMap, json['sort']),
    );

Map<String, dynamic> _$GetMemosQueryToJson(GetMemosQuery instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'tags': instance.tags,
      'sort': _$MemoSortEnumMap[instance.sort],
    };

const _$MemoSortEnumMap = {
  MemoSort.createdAtAsc: 'created_at_asc',
  MemoSort.createdAtDesc: 'created_at_desc',
  MemoSort.updatedAtAsc: 'updated_at_asc',
  MemoSort.updatedAtDesc: 'updated_at_desc',
};

CreateMemoRequest _$CreateMemoRequestFromJson(Map<String, dynamic> json) =>
    CreateMemoRequest(
      raw: json['raw'] as String,
      tagNames:
          (json['tag_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      needProofreading: json['need_proofreading'] as bool? ?? false,
    );

Map<String, dynamic> _$CreateMemoRequestToJson(CreateMemoRequest instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'tag_names': instance.tagNames,
      'need_proofreading': instance.needProofreading,
    };

UpdateBodyRequest _$UpdateBodyRequestFromJson(Map<String, dynamic> json) =>
    UpdateBodyRequest(body: json['body'] as String);

Map<String, dynamic> _$UpdateBodyRequestToJson(UpdateBodyRequest instance) =>
    <String, dynamic>{'body': instance.body};

UpdateTitleRequest _$UpdateTitleRequestFromJson(Map<String, dynamic> json) =>
    UpdateTitleRequest(title: json['title'] as String);

Map<String, dynamic> _$UpdateTitleRequestToJson(UpdateTitleRequest instance) =>
    <String, dynamic>{'title': instance.title};

UpdateTagsRequest _$UpdateTagsRequestFromJson(Map<String, dynamic> json) =>
    UpdateTagsRequest(
      tagNames:
          (json['tag_names'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UpdateTagsRequestToJson(UpdateTagsRequest instance) =>
    <String, dynamic>{'tag_names': instance.tagNames};

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) =>
    AuthRequest(userId: json['user_id'] as String);

Map<String, dynamic> _$AuthRequestToJson(AuthRequest instance) =>
    <String, dynamic>{'user_id': instance.userId};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  accessToken: json['access_token'] as String,
  tokenType: $enumDecode(_$TokenTypeEnumMap, json['token_type']),
  expiredAt:
      json['expired_at'] == null
          ? null
          : DateTime.parse(json['expired_at'] as String),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': _$TokenTypeEnumMap[instance.tokenType]!,
      'expired_at': instance.expiredAt?.toIso8601String(),
    };

const _$TokenTypeEnumMap = {TokenType.bearer: 'bearer'};
