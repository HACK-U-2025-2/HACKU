abstract interface class UserIdRepository {
  /// ユーザIDを取得
  Future<String> getUserId();
}
