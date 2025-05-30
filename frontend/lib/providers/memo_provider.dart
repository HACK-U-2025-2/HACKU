import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_provider.g.dart';

@riverpod
Future<Memo> memo(Ref ref, MemoId id) async {
  return ref.watch(memoRepositoryProvider).getMemoById(id);
}

@riverpod
Future<List<MemoPreview>> relatedMemos(Ref ref, MemoId id) async {
  return ref.watch(memoRepositoryProvider).getRelatedMemos(id);
}
