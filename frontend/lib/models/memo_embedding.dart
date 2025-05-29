import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/models/memo.dart';

part 'memo_embedding.freezed.dart';
part 'memo_embedding.g.dart';

@freezed
sealed class MemoEmbedding with _$MemoEmbedding {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MemoEmbedding({
    @MemoIdJsonConverter() required MemoId id,
    required String title,
    required List<double> simpleEmbedding,
  }) = _MemoEmbedding;

  factory MemoEmbedding.fromJson(Map<String, dynamic> json) =>
      _$MemoEmbeddingFromJson(json);
}
