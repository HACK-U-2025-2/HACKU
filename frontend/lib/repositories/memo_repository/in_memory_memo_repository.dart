import 'package:collection/collection.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
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
  Future<Memo> getMemoById(MemoId id) async =>
      _memos[id] ?? (throw MemoNotFoundException(id));

  @override
  Future<Memo> addMemo(String rawMemo) async {
    final memoId = MemoId(++_nextId);
    return _memos[memoId] = Memo(
      id: memoId,
      title: 'Memo $_nextId',
      body: '$rawMemoの要約',
      raw: rawMemo,
      createdAt: DateTime.now(),
      tags: _pickTags(),
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
  Future<void> updateMemoTags(MemoId id, List<String> newTags) {
    final updatedTags =
        newTags.map((tagName) {
          final existingTag = _tags.values.firstWhereOrNull(
            (tag) => tag.name == tagName,
          );
          if (existingTag != null) return existingTag;
          final newId = TagId(_tags.length);
          final newTag = Tag(id: newId, name: tagName);
          _tags[newId] = newTag;
          return newTag;
        }).toList();

    return _updateMemo(
      id,
      (memo) => memo.copyWith(tags: updatedTags, updatedAt: DateTime.now()),
    );
  }

  @override
  Future<void> deleteMemo(MemoId id) async {
    if (_memos.remove(id) == null) throw MemoNotFoundException(id);
  }

  @override
  Future<List<Tag>> getTags({String? keyword}) async {
    if (keyword == null || keyword.isEmpty) {
      return _tags.values.toList();
    }
    return _tags.values.where((tag) => tag.name.contains(keyword)).toList();
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
