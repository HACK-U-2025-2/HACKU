import 'package:frontend/repositories/user_id_repository/user_id_repository.dart';

class ValueUserIdRepository implements UserIdRepository {
  ValueUserIdRepository(this.userId);
  final String userId;

  @override
  Future<String> getUserId() async {
    return userId;
  }
}
