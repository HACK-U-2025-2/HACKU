// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMemosQuery _$GetMemosQueryFromJson(Map<String, dynamic> json) =>
    GetMemosQuery(
      keyword: json['keyword'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      sort: $enumDecodeNullable(_$MemoSortOrderEnumMap, json['sort']),
    );

Map<String, dynamic> _$GetMemosQueryToJson(GetMemosQuery instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'tags': instance.tags,
      'sort': _$MemoSortOrderEnumMap[instance.sort],
    };

const _$MemoSortOrderEnumMap = {
  MemoSortOrder.createdAtAsc: 'created_at_asc',
  MemoSortOrder.createdAtDesc: 'created_at_desc',
  MemoSortOrder.updatedAtAsc: 'updated_at_asc',
  MemoSortOrder.updatedAtDesc: 'updated_at_desc',
};

MemoCreateRequest _$MemoCreateRequestFromJson(Map<String, dynamic> json) =>
    MemoCreateRequest(
      raw: json['raw'] as String,
      tagNames:
          (json['tag_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      needProofreading: json['need_proofreading'] as bool? ?? false,
    );

Map<String, dynamic> _$MemoCreateRequestToJson(MemoCreateRequest instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'tag_names': instance.tagNames,
      'need_proofreading': instance.needProofreading,
    };

MemoBodyUpdateRequest _$MemoBodyUpdateRequestFromJson(
  Map<String, dynamic> json,
) => MemoBodyUpdateRequest(body: json['body'] as String);

Map<String, dynamic> _$MemoBodyUpdateRequestToJson(
  MemoBodyUpdateRequest instance,
) => <String, dynamic>{'body': instance.body};

MemoTitleUpdateRequest _$MemoTitleUpdateRequestFromJson(
  Map<String, dynamic> json,
) => MemoTitleUpdateRequest(title: json['title'] as String);

Map<String, dynamic> _$MemoTitleUpdateRequestToJson(
  MemoTitleUpdateRequest instance,
) => <String, dynamic>{'title': instance.title};

MemoTagsUpdateRequest _$MemoTagsUpdateRequestFromJson(
  Map<String, dynamic> json,
) => MemoTagsUpdateRequest(
  tagNames:
      (json['tag_names'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$MemoTagsUpdateRequestToJson(
  MemoTagsUpdateRequest instance,
) => <String, dynamic>{'tag_names': instance.tagNames};

MemoFavoriteUpdateRequest _$MemoFavoriteUpdateRequestFromJson(
  Map<String, dynamic> json,
) => MemoFavoriteUpdateRequest(isFavorite: json['is_favorite'] as bool);

Map<String, dynamic> _$MemoFavoriteUpdateRequestToJson(
  MemoFavoriteUpdateRequest instance,
) => <String, dynamic>{'is_favorite': instance.isFavorite};

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
