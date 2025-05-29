import 'package:json_annotation/json_annotation.dart';

part 'request_body.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum MemoSortOrder { createdAtAsc, createdAtDesc, updatedAtAsc, updatedAtDesc }

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GetMemosQuery {
  const GetMemosQuery({this.keyword, this.tags, this.sort});

  factory GetMemosQuery.fromJson(Map<String, dynamic> json) =>
      _$GetMemosQueryFromJson(json);
  final String? keyword;
  final List<String>? tags;
  final MemoSortOrder? sort;

  Map<String, dynamic> toJson() => _$GetMemosQueryToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MemoCreateRequest {
  const MemoCreateRequest({
    required this.raw,
    this.tagNames = const [],
    this.needProofreading = false,
    this.needGenerateTags = true,
  });

  factory MemoCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$MemoCreateRequestFromJson(json);
  final String raw;
  final List<String> tagNames;
  final bool needProofreading;
  final bool needGenerateTags;

  Map<String, dynamic> toJson() => _$MemoCreateRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MemoBodyUpdateRequest {
  const MemoBodyUpdateRequest({required this.body});

  factory MemoBodyUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$MemoBodyUpdateRequestFromJson(json);
  final String body;

  Map<String, dynamic> toJson() => _$MemoBodyUpdateRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MemoTitleUpdateRequest {
  const MemoTitleUpdateRequest({required this.title});

  factory MemoTitleUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$MemoTitleUpdateRequestFromJson(json);
  final String title;

  Map<String, dynamic> toJson() => _$MemoTitleUpdateRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MemoTagsUpdateRequest {
  const MemoTagsUpdateRequest({required this.tagNames});

  factory MemoTagsUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$MemoTagsUpdateRequestFromJson(json);
  final List<String> tagNames;

  Map<String, dynamic> toJson() => _$MemoTagsUpdateRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MemoFavoriteUpdateRequest {
  const MemoFavoriteUpdateRequest({required this.isFavorite});

  factory MemoFavoriteUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$MemoFavoriteUpdateRequestFromJson(json);
  final bool isFavorite;

  Map<String, dynamic> toJson() => _$MemoFavoriteUpdateRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AuthRequest {
  const AuthRequest({required this.userId});

  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);
  final String userId;

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}

enum TokenType {
  bearer;

  String toHeaderValue(String value) {
    switch (this) {
      case TokenType.bearer:
        return 'Bearer $value';
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.tokenType,
    this.expiredAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  final String accessToken;
  final TokenType tokenType;
  final DateTime? expiredAt;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  /// ヘッダーに渡す値
  String get token => tokenType.toHeaderValue(accessToken);

  /// トークンが有効かどうか
  bool validate() {
    if (expiredAt == null) return true;
    final now = DateTime.now();
    return now.isBefore(expiredAt!);
  }
}
