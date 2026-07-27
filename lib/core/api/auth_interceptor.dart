import 'dart:async';

import 'package:dio/dio.dart';

import '../models/token_pair.dart';
import '../services/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.storage,
    required this.refreshClient,
    required this.onSessionExpired,
  });

  final TokenStorage storage;

  final Dio refreshClient;

  final Future<void> Function() onSessionExpired;

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
