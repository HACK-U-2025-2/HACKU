import 'dart:math';

import 'package:collection/collection.dart';
import 'package:frontend/models/tag.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/widgets/dialogs/sort_dialog.dart';

/// メモのリポジトリのインメモリ実装。Dockerを起動しない場合のデバッグ時のみ使用する。
class InMemoryMemoRepository implements MemoRepository {
  static const int _pickTagsCount = 2;

  final Map<MemoId, Memo> _memos = {};
  final Map<TagId, Tag> _tags = {
    const TagId(1): const Tag(id: TagId(1), name: 'tag1'),
    const TagId(2): const Tag(id: TagId(2), name: 'tag2'),
    const TagId(3): const Tag(id: TagId(3), name: 'tag3'),
  };
  int _nextId = 0;

  @override
  Future<List<MemoPreview>> getMemos({
    String? keyword,
    List<String>? tagNames,
    MemoSortOption? sort,
  }) async =>
      _memos.values
          .where((memo) {
            final matchesKeyword =
                keyword == null ||
                memo.title.contains(keyword) ||
                memo.body.contains(keyword);
            final matchesTags =
                tagNames == null ||
                tagNames.isEmpty ||
                tagNames.every(
                  (name) => memo.tags.any((tag) => tag.name == name),
                );
            return matchesKeyword && matchesTags;
          })
          .map(
            (memo) => MemoPreview(
              id: memo.id,
              title: memo.title,
              body: memo.body,
              createdAt: memo.createdAt,
              updatedAt: memo.updatedAt,
            ),
          )
          .sorted((a, b) {
            if (sort == null) return 0;
            return switch (sort.mode) {
              MemoSortMode.createdAt =>
                sort.isAsc
                    ? a.createdAt.compareTo(b.createdAt)
                    : b.createdAt.compareTo(a.createdAt),
              MemoSortMode.updatedAt =>
                sort.isAsc
                    ? (a.updatedAt ?? a.createdAt).compareTo(
                      b.updatedAt ?? b.createdAt,
                    )
                    : (b.updatedAt ?? b.createdAt).compareTo(
                      a.updatedAt ?? a.createdAt,
                    ),
            };
          })
          .toList();

  @override
  Future<List<MemoPreview>> getRelatedMemos(MemoId id) async {
    final memo = _memos[id];
    if (memo == null) throw MemoNotFoundException(id);

    // 仮で最新のメモ0~3件を返す
    return _memos.values
        .where((m) => m.id != id) // 自分自身を除外
        .take(3)
        .map(
          (m) => MemoPreview(
            id: m.id,
            title: m.title,
            body: m.body,
            createdAt: m.createdAt,
            updatedAt: m.updatedAt,
          ),
        )
        .toList();
  }

  @override
  Future<List<MemoPreview>> getRandomMemos() async {
    final shuffled = _memos.values.toList()..shuffle();
    return shuffled
        .take(3)
        .map(
          (memo) => MemoPreview(
            id: memo.id,
            title: memo.title,
            body: memo.body,
            createdAt: memo.createdAt,
            updatedAt: memo.updatedAt,
          ),
        )
        .toList();
  }

  @override
  Future<Memo> getMemoById(MemoId id) async =>
      _memos[id] ?? (throw MemoNotFoundException(id));

  @override
  Future<Memo> addMemo(String rawMemo) async {
    final memoId = MemoId(++_nextId);
    final pickedTags = _pickTags();
    // usedNumをインクリメント（新規タグも考慮）
    for (final tag in pickedTags) {
      final current = _tags[tag.id];
      if (current != null) {
        _tags[tag.id] = current.copyWith(usedNum: current.usedNum + 1);
      } else {
        _tags[tag.id] = tag.copyWith(usedNum: 1);
      }
    }
    return _memos[memoId] = Memo(
      id: memoId,
      title: 'Memo $_nextId',
      body: '$rawMemoの要約',
      raw: rawMemo,
      createdAt: DateTime.now(),
      tags: pickedTags,
    );
  }

  @override
  Future<void> updateMemoTitle(MemoId id, String newTitle) => _updateMemo(
    id,
    (memo) => memo.copyWith(title: newTitle, updatedAt: DateTime.now()),
  );

  @override
  Future<void> updateMemoBody(MemoId id, String newBody) => _updateMemo(
    id,
    (memo) => memo.copyWith(body: newBody, updatedAt: DateTime.now()),
  );

  @override
  Future<void> updateMemoTags(MemoId id, List<String> newTags) async {
    final memo = _memos[id];
    if (memo == null) throw MemoNotFoundException(id);
    final oldTags = memo.tags;
    final oldTagNames = oldTags.map((t) => t.name).toSet();
    final newTagNames = newTags.toSet();

    // 追加されたタグ
    final addedTagNames = newTagNames.difference(oldTagNames);
    // 削除されたタグ
    final removedTagNames = oldTagNames.difference(newTagNames);

    // usedNumを増減
    for (final tagName in addedTagNames) {
      final existingTag = _tags.values.firstWhereOrNull(
        (tag) => tag.name == tagName,
      );
      if (existingTag != null) {
        _tags[existingTag.id] = existingTag.copyWith(
          usedNum: existingTag.usedNum + 1,
        );
      } else {
        // 新規タグIDは最大ID+1で採番
        final newId = TagId(_tags.keys.map((id) => id.value).fold(0, max) + 1);
        final newTag = Tag(id: newId, name: tagName, usedNum: 1);
        _tags[newId] = newTag;
      }
    }
    for (final tagName in removedTagNames) {
      final tag = _tags.values.firstWhereOrNull((tag) => tag.name == tagName);
      if (tag != null && tag.usedNum > 0) {
        _tags[tag.id] = tag.copyWith(usedNum: tag.usedNum - 1);
      }
    }

    // 新しいタグリストを構築
    final updatedTags =
        newTags
            .map(
              (tagName) =>
                  _tags.values.firstWhere((tag) => tag.name == tagName),
            )
            .toList();

    await _updateMemo(
      id,
      (memo) => memo.copyWith(tags: updatedTags, updatedAt: DateTime.now()),
    );
  }

  @override
  Future<void> updateMemoFavorite(MemoId id, {required bool isFavorite}) =>
      _updateMemo(
        id,
        (memo) =>
            memo.copyWith(isFavorite: isFavorite, updatedAt: DateTime.now()),
      );

  @override
  Future<void> deleteMemo(MemoId id) async {
    final memo = _memos[id];
    if (memo == null) throw MemoNotFoundException(id);
    // usedNumをデクリメント
    for (final tag in memo.tags) {
      final current = _tags[tag.id];
      if (current != null && current.usedNum > 0) {
        _tags[tag.id] = current.copyWith(usedNum: current.usedNum - 1);
      }
    }
    _memos.remove(id);
  }

  @override
  Future<List<Tag>> getTags({String? keyword}) async {
    if (keyword == null || keyword.isEmpty) {
      return _tags.values.toList();
    }
    return _tags.values.where((tag) => tag.name.contains(keyword)).toList();
  }

  @override
  Future<List<MemoEmbedding>> getMemoEmbeddings() async {
    return _memos.values.map((memo) {
      // 仮の埋め込み表現を生成
      // ３次元の正規化されたベクトル
      // タイトルと本文のハッシュ値を使ってダミーの埋め込みを生成
      final hash = memo.title.hashCode ^ memo.body.hashCode;
      final embedding = List<double>.generate(
        3,
        (i) => ((hash >> (i * 8)) & 0xFF) / 255.0,
      );
      final norm = sqrt(embedding.fold<double>(0, (sum, v) => sum + v * v));
      final normalizedEmbedding =
          norm == 0 ? embedding : embedding.map((v) => v / norm).toList();

      return MemoEmbedding(
        id: memo.id,
        title: memo.title,
        simpleEmbedding: normalizedEmbedding,
      );
    }).toList();
  }

  // メモの更新処理を共通化、非同期処理にしている
  Future<void> _updateMemo(MemoId id, Memo Function(Memo) update) async {
    final memo = _memos[id];
    if (memo == null) throw MemoNotFoundException(id);
    _memos[id] = update(memo);
  }

  // タグ選択の仮実装
  List<Tag> _pickTags() {
    final shuffled = _tags.values.toList()..shuffle();
    return shuffled.sublist(0, _pickTagsCount); // タグをランダムに選択
  }
}
