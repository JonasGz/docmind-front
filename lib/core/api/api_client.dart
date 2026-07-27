import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../services/token_storage_provider.dart';
import 'auth_interceptor.dart';

part 'api_client.g.dart';

BaseOptions _baseOptions() => BaseOptions(
  baseUrl: AppConfig.apiBaseUrl,
  connectTimeout: const Duration(seconds: 15),
  // A resposta do chat espera o RAG completo — busca, recuperação e geração.
  // Quinze segundos derrubariam perguntas legítimas.
  receiveTimeout: const Duration(seconds: 90),
  contentType: Headers.jsonContentType,
);

/// Cliente sem o interceptor de autenticação, usado para renovar a sessão e
/// para repetir a requisição que falhou. Se ele passasse pelo interceptor,
/// um 401 na própria renovação entraria em recursão.
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
