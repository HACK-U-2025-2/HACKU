import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';

abstract interface class MemoRepository {
  /// メモの一覧を取得する
  ///
  /// TODO: 引数にクエリ系のパラメータを追加。サーバーの実装に合わせてenumなどを用意する
  Future<List<MemoPreview>> getMemos();

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

class MemoUnknownException implements Exception {
  MemoUnknownException(this.error);
  final Object error;

  @override
  String toString() => 'Unknown error occurred: $error';
}
