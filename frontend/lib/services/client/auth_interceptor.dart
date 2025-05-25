import 'package:dio/dio.dart';
import 'package:frontend/repositories/auth_repository/auth_repository.dart';
import 'package:frontend/repositories/user_id_repository/user_id_repository.dart';
import 'package:frontend/services/client/auth_api_client.dart';
import 'package:frontend/types/request_body.dart';

abstract class AuthInterceptor extends Interceptor {
  AuthInterceptor();
}

class JWTAuthInterceptor extends AuthInterceptor {
  JWTAuthInterceptor({
    required this.authRepository,
    required this.userIdRepository,
    required this.authApiClient,
  });

  final AuthRepository authRepository;
  final UserIdRepository userIdRepository;
  final AuthApiClient authApiClient;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var auth = await authRepository.getAuth();
    if (auth == null || !auth.validate()) {
      try {
        auth = await _refresh(auth);
      } on Exception catch (e) {
        return handler.reject(DioException(requestOptions: options, error: e));
      }
    }
    options.headers['Authorization'] = auth.token;

    return handler.next(options);
  }

  Future<AuthResponse> _refresh(AuthResponse? auth) async {
    final userId = await userIdRepository.getUserId();
    final newAuth = await authApiClient.getAuthToken(
      request: AuthRequest(userId: userId),
    );
    await authRepository.setAuth(newAuth);
    return newAuth;
  }
}
