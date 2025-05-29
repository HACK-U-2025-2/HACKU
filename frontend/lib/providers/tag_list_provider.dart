import 'package:frontend/models/tag.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/providers/tag_search_query_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_list_provider.g.dart';

@riverpod
Future<List<Tag>> tagList(Ref ref) async {
  return ref.watch(memoRepositoryProvider).getTags();
}

@riverpod
Future<List<Tag>> filteredTagList(Ref ref) async {
  final keywordQuery = ref.watch(tagSearchKeywordProvider);

  return ref.watch(memoRepositoryProvider).getTags(keyword: keywordQuery);
}
