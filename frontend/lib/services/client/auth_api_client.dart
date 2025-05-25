import 'package:dio/dio.dart';
import 'package:frontend/types/request_body.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  /// ユーザIDからトークン発行
  @POST('/auth')
  Future<AuthResponse> getAuthToken({@Body() required AuthRequest request});
}
