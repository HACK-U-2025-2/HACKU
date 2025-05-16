import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/models/tag.dart';

part 'memo.freezed.dart';
part 'memo.g.dart';

extension type const MemoId(int value) {}

@freezed
sealed class Memo with _$Memo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Memo({
    @MemoIdJsonConverter() required MemoId id,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default([]) List<Tag> tags,
    DateTime? updatedAt,
  }) = _Memo;

  factory Memo.fromJson(Map<String, dynamic> json) => _$MemoFromJson(json);
}

final class MemoIdJsonConverter implements JsonConverter<MemoId, int> {
  const MemoIdJsonConverter();

  @override
  MemoId fromJson(int json) => MemoId(json);

  @override
  int toJson(MemoId object) => object.value;
}
