import 'package:flutter/foundation.dart';
import 'package:frontend/widgets/dialogs/sort_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_search_query_provider.g.dart';

@riverpod
class MemoSearchKeyword extends _$MemoSearchKeyword {
  @override
  String build() {
    return '';
  }

  void setKeyword(String keyword) {
    if (state == keyword) {
      // クエリの実体が変わらないなら更新しない
      return;
    }
    state = keyword;
  }
}

@riverpod
class MemoSearchTagNames extends _$MemoSearchTagNames {
  @override
  Set<String> build() {
    return {};
  }

  void addTagName(String tagName) {
    state = {...state, tagName};
  }

  void removeTagName(String tagName) {
    state = {...state}..remove(tagName);
  }

  void clearTagNames() {
    state = {};
  }

  void setTagNames(Set<String> tagNames) {
    if (setEquals(state, tagNames)) {
      // クエリの実体が変わらないなら更新しない
      return;
    }
    state = tagNames;
  }
}

@riverpod
class MemoSearchSortOption extends _$MemoSearchSortOption {
  @override
  MemoSortOption build() {
    return MemoSortOption(isAsc: false, mode: MemoSortMode.createdAt);
  }

  void setSortOption(MemoSortOption sortOption) {
    state = sortOption;
  }
}
