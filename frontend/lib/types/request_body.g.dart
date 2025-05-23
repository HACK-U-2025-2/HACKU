// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  accessToken: json['access_token'] as String,
  tokenType: $enumDecode(_$TokenTypeEnumMap, json['token_type']),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': _$TokenTypeEnumMap[instance.tokenType]!,
    };

const _$TokenTypeEnumMap = {TokenType.bearer: 'bearer'};
