import 'package:dio/dio.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:frontend/services/client/auth_api_client.dart';
import 'package:frontend/services/client/auth_interceptor.dart';
import 'package:frontend/services/client/memo_api_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_platform/universal_platform.dart';

part 'service_provider.g.dart';

@Riverpod(keepAlive: true)
MemoApiClient memoApiClient(Ref ref) {
  return MemoApiClient(ref.watch(authDioProvider));
}

@Riverpod(keepAlive: true)
AuthApiClient authApiClient(Ref ref) {
  return AuthApiClient(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(BaseOptions(baseUrl: ref.watch(baseUrlProvider)));
}

@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  final authInterceptor = JWTAuthInterceptor(
    authRepository: ref.watch(authRepositoryProvider),
    userIdRepository: ref.watch(userIdRepositoryProvider),
    authApiClient: ref.watch(authApiClientProvider),
  );
  return Dio(BaseOptions(baseUrl: ref.watch(baseUrlProvider)))
    ..interceptors.add(authInterceptor);
}

@Riverpod(keepAlive: true)
String baseUrl(Ref ref) {
  // AndroidエミュレータでのホストPCのlocalhostのIPアドレスは10.0.2.2にマッピングされる
  final localhost = UniversalPlatform.isAndroid ? '10.0.2.2' : 'localhost';
  const port = 8000;
  return 'http://$localhost:$port';
}
