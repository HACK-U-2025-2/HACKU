import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/models/memo.dart';

part 'memo_preview.freezed.dart';
part 'memo_preview.g.dart';

@freezed
sealed class MemoPreview with _$MemoPreview {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MemoPreview({
    @MemoIdJsonConverter() required MemoId id,
    required String title,
    required String body,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MemoPreview;

  factory MemoPreview.fromJson(Map<String, dynamic> json) =>
      _$MemoPreviewFromJson(json);
}
