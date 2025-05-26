import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/client/auth_api_client.dart';
import 'package:frontend/types/request_body.dart';

void main() {
  late AuthApiClient authClient;

  // APIのベースURL。ローカルDockerで動いていることを前提とする
  const baseUrl = 'http://localhost:8000';

  setUp(() async {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    authClient = AuthApiClient(dio);
  });

  group('AuthApiClient', () {
    test('Get auth token', () async {
      const userId = 'test_user_id';
      final authResponse = await authClient.getAuthToken(
        request: const AuthRequest(userId: userId),
      );
      expect(authResponse.token, isNotEmpty);
      expect(authResponse.expiredAt, isNotNull);
    });
  });
}
