import 'package:frontend/repositories/auth_repository/auth_repository.dart';
import 'package:frontend/repositories/auth_repository/shared_preferences_auth_repository.dart';
import 'package:frontend/repositories/memo_repository/in_memory_memo_repository.dart';
import 'package:frontend/repositories/memo_repository/memo_repository.dart';
import 'package:frontend/repositories/user_id_repository/device_user_id_repository.dart';
import 'package:frontend/repositories/user_id_repository/user_id_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_provider.g.dart';

@Riverpod(keepAlive: true)
MemoRepository memoRepository(Ref ref) {
  return InMemoryMemoRepository(); // 本番環境では実装を差し替える
  // return ApiClientMemoRepository(ref.watch(memoApiClientProvider));
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return SharedPreferencesAuthRepository();
}

@Riverpod(keepAlive: true)
UserIdRepository userIdRepository(Ref ref) {
  return DeviceUserIdRepository();
}
