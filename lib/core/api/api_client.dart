import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../services/token_storage_provider.dart';
import 'auth_interceptor.dart';

part 'api_client.g.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: AppConfig.apiBaseUrl,
  connectTimeout: const Duration(seconds: 15),

  receiveTimeout: const Duration(seconds: 90),
  contentType: Headers.jsonContentType,
);

@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) => Dio(_baseOptions());

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(_baseOptions());

  dio.interceptors.add(
    AuthInterceptor(
      storage: ref.watch(tokenStorageProvider),
      refreshClient: ref.watch(refreshDioProvider),
      onSessionExpired: () async {
        ref.invalidate(tokenStorageProvider);
      },
    ),
  );

  return dio;
}
