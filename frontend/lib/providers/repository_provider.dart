import 'package:frontend/repositories/memo_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_provider.g.dart';

@Riverpod(keepAlive: true)
MemoRepository memoRepository(Ref ref) {
  return InMemoryMemoRepository(); // ここを切り替えることで本番環境にアクセス可能
}
