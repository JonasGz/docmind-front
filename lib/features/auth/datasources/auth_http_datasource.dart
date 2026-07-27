import 'package:dio/dio.dart';

import '../../../core/models/token_pair.dart';
import '../../../core/models/user.dart';
import 'auth_datasource.dart';

class AuthHttpDatasource implements AuthDatasource {
  const AuthHttpDatasource(this._dio);

  final Dio _dio;

  @override
  Future<TokenPair> signInWithGoogle(String idToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/google',
      data: {'id_token': idToken},

      options: Options(extra: const {'skipAuth': true}),
    );
    return TokenPair.fromJson(response.data!);
  }

  @override
  Future<TokenPair> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(extra: const {'skipAuth': true}),
    );
    return TokenPair.fromJson(response.data!);
  }

  @override
  Future<User> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/me');
    return User.fromJson(response.data!);
  }
}
