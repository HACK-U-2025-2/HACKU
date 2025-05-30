import 'package:frontend/models/memo_embedding.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/providers/memo_search_query_provider.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_list_provider.g.dart';

@riverpod
Future<List<MemoPreview>> memoList(Ref ref) async {
  final keywordQuery = ref.watch(memoSearchKeywordProvider);
  final tagNamesQuery = ref.watch(memoSearchTagNamesProvider);
  final sortOptionQuery = ref.watch(memoSearchSortOptionProvider);

  return ref
      .watch(memoRepositoryProvider)
      .getMemos(
        keyword: keywordQuery,
        tagNames: tagNamesQuery.toList(),
        sort: sortOptionQuery,
      );
}

@riverpod
class RandomMemoList extends _$RandomMemoList {
  @override
  Future<List<MemoPreview>> build() async {
    return ref.watch(memoRepositoryProvider).getRandomMemos();
  }

  /// キャッシュ上で更新する
  /// タイトル更新時などに呼び出すことを想定
  void updateMemo(Memo memo) {
    state = AsyncData(
      (state.value ?? [])
          .map((m) => m.id == memo.id ? memo.toPreview() : m)
          .toList(),
    );
  }
}

@riverpod
Future<List<MemoEmbedding>> memoEmbeddings(Ref ref) async {
  return ref.watch(memoRepositoryProvider).getMemoEmbeddings();
}
