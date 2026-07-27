import 'dart:async';

import 'package:dio/dio.dart';

import '../models/token_pair.dart';
import '../services/token_storage.dart';

/// Injeta o access token e renova a sessão quando ele expira.
///
/// A renovação é **single-flight**: se várias requisições receberem 401 ao
/// mesmo tempo, apenas uma chama `POST /auth/refresh` e as demais aguardam o
/// resultado dela. Sem isso o polling de documentos a cada dois segundos
/// dispararia várias renovações simultâneas — e a maioria falharia, porque o
/// backend invalida o refresh token a cada uso.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.storage,
    required this.refreshClient,
    required this.onSessionExpired,
  });

  final TokenStorage storage;

  /// Dio separado, sem este interceptor: renovar usando o cliente
  /// interceptado entraria em recursão no primeiro 401.
  final Dio refreshClient;

  /// Chamado quando a renovação falha — a sessão acabou de verdade.
  final Future<void> Function() onSessionExpired;

  /// A renovação em andamento, se houver. É o que torna o fluxo
  /// single-flight.
  Future<TokenPair?>? _refreshInFlight;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    final tokens = await storage.read();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = err.requestOptions.extra['retried'] == true;

    if (!isUnauthorized ||
        alreadyRetried ||
        err.requestOptions.extra['skipAuth'] == true) {
      return handler.next(err);
    }

    final tokens = await _refresh();
    if (tokens == null) {
      await onSessionExpired();
      return handler.next(err);
    }

    try {
      // Repete a requisição original com o token novo.
      final options = err.requestOptions
        ..extra['retried'] = true
        ..headers['Authorization'] = 'Bearer ${tokens.accessToken}';

      final response = await refreshClient.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  Future<TokenPair?> _refresh() {
    // Se já há uma renovação em curso, aguarda aquela em vez de abrir outra.
    return _refreshInFlight ??= _performRefresh().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<TokenPair?> _performRefresh() async {
    final current = await storage.read();
    if (current == null) return null;

    try {
      final response = await refreshClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': current.refreshToken},
        options: Options(extra: const {'skipAuth': true}),
      );

      final tokens = TokenPair.fromJson(response.data!);
      await storage.write(tokens);
      return tokens;
    } on DioException {
      await storage.clear();
      return null;
    }
  }
}
