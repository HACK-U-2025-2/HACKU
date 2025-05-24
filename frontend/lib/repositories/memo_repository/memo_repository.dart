import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/types/request_body.dart';

export 'package:frontend/types/request_body.dart';

abstract interface class MemoRepository {
  /// メモの一覧を取得する
  Future<List<MemoPreview>> getMemos({
    String? keyword,
    List<String>? tagNames,
    MemoSort? sort,
  });

  /// メモのIDからメモを取得する
  Future<Memo> getMemoById(MemoId id);

  /// メモを追加する。文字起こしなどの文字列を引数に取る
  Future<Memo> addMemo(String rawMemo);

  /// メモのタイトルを更新する
  Future<void> updateMemoTitle(MemoId id, String newTitle);

  /// メモの本文を更新する
  Future<void> updateMemoBody(MemoId id, String newBody);

  /// メモのタグを更新する
  Future<void> updateMemoTags(MemoId id, List<String> newTags);

  /// メモを削除する
  Future<void> deleteMemo(MemoId id);
}

class MemoNotFoundException implements Exception {
  MemoNotFoundException(this.id);
  final MemoId id;

  @override
  String toString() => 'Memo with id $id not found';
}

class MemoValidationException implements Exception {
  MemoValidationException(this.error);
  final Object error;

  @override
  String toString() => 'Validation error occurred: $error';
}

class MemoServerException implements Exception {
  MemoServerException(this.error);
  final Object error;

  @override
  String toString() => 'Server error occurred: $error';
}

class MemoUnknownException implements Exception {
  MemoUnknownException(this.error);
  final Object error;

  @override
  String toString() => 'Unknown error occurred: $error';
}
