import 'dart:convert';

import 'package:frontend/repositories/auth_repository/auth_repository.dart';
import 'package:frontend/types/request_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'auth';

class SharedPreferencesAuthRepository implements AuthRepository {
  final _prefs = SharedPreferencesAsync();

  @override
  Future<AuthResponse?> getAuth() async {
    final authString = await _prefs.getString(_key);
    if (authString == null) return null;
    final authMap = jsonDecode(authString) as Map<String, dynamic>;
    return AuthResponse.fromJson(authMap);
  }

  @override
  Future<void> setAuth(AuthResponse auth) {
    return _prefs.setString(_key, jsonEncode(auth.toJson()));
  }
}
