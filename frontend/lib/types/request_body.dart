import 'package:json_annotation/json_annotation.dart';

part 'request_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CreateMemoRequest {
  const CreateMemoRequest({
    required this.raw,
    this.tagNames = const [],
    this.needProofreading = false,
  });

  factory CreateMemoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMemoRequestFromJson(json);
  final String raw;
  final List<String> tagNames;
  final bool needProofreading;

  Map<String, dynamic> toJson() => _$CreateMemoRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UpdateBodyRequest {
  const UpdateBodyRequest({required this.body});

  factory UpdateBodyRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBodyRequestFromJson(json);
  final String body;

  Map<String, dynamic> toJson() => _$UpdateBodyRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UpdateTitleRequest {
  const UpdateTitleRequest({required this.title});

  factory UpdateTitleRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTitleRequestFromJson(json);
  final String title;

  Map<String, dynamic> toJson() => _$UpdateTitleRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class UpdateTagsRequest {
  const UpdateTagsRequest({required this.tagNames});

  factory UpdateTagsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTagsRequestFromJson(json);
  final List<String> tagNames;

  Map<String, dynamic> toJson() => _$UpdateTagsRequestToJson(this);
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
