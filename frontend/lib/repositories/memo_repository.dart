import 'package:collection/collection.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/tag.dart';

abstract interface class MemoRepository {
  Future<List<Memo>> getAllMemos(); // 引数にクエリ系のパラメータを追加予定
  Future<Memo> getMemoById(MemoId id);
  Future<void> addMemo(String rawMemo);
  Future<void> updateMemoTitle(MemoId id, String newTitle);
  Future<void> updateMemoBody(MemoId id, String newBody);
  Future<void> updateMemoTags(MemoId id, List<String> newTags);
  Future<void> deleteMemo(MemoId id);
}

class MemoNotFoundException implements Exception {
  MemoNotFoundException(this.id);
  final MemoId id;

  @override
  String toString() => 'Memo with id $id not found';
}

class InMemoryMemoRepository implements MemoRepository {
  final Map<MemoId, Memo> _memos = {};
  int _idHeader = 0;

  @override
  Future<List<Memo>> getAllMemos() async {
    return _memos.values.toList();
  }

  @override
  Future<Memo> getMemoById(MemoId id) async {
    return _memos[id] ?? (throw MemoNotFoundException(id));
  }

  @override
  Future<void> addMemo(String rawMemo) async {
    final id = ++_idHeader;
    final memoId = MemoId(id);
    final newMemo = Memo(
      id: memoId,
      title: 'Memo $id',
      body: '$rawMemoの要約',
      raw: rawMemo,
      createdAt: DateTime.now(),
    );
    _memos[memoId] = newMemo;
  }

  @override
  Future<void> updateMemoTitle(MemoId id, String newTitle) async {
    if (_memos[id] == null) {
      throw MemoNotFoundException(id);
    }
    _memos[id] = _memos[id]!.copyWith(title: newTitle);
  }

  @override
  Future<void> updateMemoBody(MemoId id, String newBody) async {
    if (_memos[id] == null) {
      throw MemoNotFoundException(id);
    }
    _memos[id] = _memos[id]!.copyWith(body: newBody);
  }

  @override
  Future<void> updateMemoTags(MemoId id, List<String> newTags) async {
    if (_memos[id] == null) {
      throw MemoNotFoundException(id);
    }
    _memos[id] = _memos[id]!.copyWith(
      tags:
          newTags.mapIndexed((i, str) => Tag(id: TagId(i), name: str)).toList(),
    );
  }

  @override
  Future<void> deleteMemo(MemoId id) async {
    if (_memos[id] == null) {
      throw MemoNotFoundException(id);
    }
    _memos.remove(id);
  }
}

// TODO: 実際にREST APIに接続して副作用するクラスを作る
// class ApiClientMemoRepository implements MemoRepository {
// }
