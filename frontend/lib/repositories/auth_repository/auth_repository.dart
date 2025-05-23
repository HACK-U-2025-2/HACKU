import 'package:frontend/types/request_body.dart';

abstract interface class AuthRepository {
  /// 認証情報を取得
  Future<AuthResponse?> getAuth();

  /// 認証情報を保存
  Future<void> setAuth(AuthResponse auth);
}
