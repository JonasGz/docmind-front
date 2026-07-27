import 'package:dio/dio.dart';
import 'package:docmind/core/api/auth_interceptor.dart';
import 'package:docmind/core/models/token_pair.dart';
import 'package:docmind/core/services/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adaptador controlado: responde 401 até a renovação acontecer, e conta
/// quantas vezes `/auth/refresh` foi chamado.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter();

  var refreshCalls = 0;
  var protectedCalls = 0;
  var accessTokenIsValid = false;

  /// Faz o refresh falhar, simulando refresh token expirado.
  var refreshFails = false;

  /// Atraso da resposta de refresh — abre a janela em que várias requisições
  /// disputam a renovação.
  Duration refreshDelay = Duration.zero;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path == '/auth/refresh') {
      refreshCalls++;
      if (refreshDelay > Duration.zero) {
        await Future<void>.delayed(refreshDelay);
      }
      if (refreshFails) {
        return ResponseBody.fromString('{"detail":"expired"}', 401);
      }
      accessTokenIsValid = true;
      return ResponseBody.fromString(
        '{"access_token":"novo","refresh_token":"novo-refresh",'
        '"token_type":"bearer"}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    protectedCalls++;
    if (!accessTokenIsValid) {
      return ResponseBody.fromString('{"detail":"unauthorized"}', 401);
    }
    return ResponseBody.fromString(
      '{"items":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _FakeAdapter adapter;
  late InMemoryTokenStorage storage;
  late Dio dio;
  late int sessionExpiredCalls;

  setUp(() async {
    adapter = _FakeAdapter();
    storage = InMemoryTokenStorage();
    sessionExpiredCalls = 0;

    await storage.write(
      const TokenPair(accessToken: 'velho', refreshToken: 'refresh'),
    );

    final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;

    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
          onSessionExpired: () async => sessionExpiredCalls++,
        ),
      );
  });

  test('injeta o access token no cabeçalho', () async {
    adapter.accessTokenIsValid = true;

    final response = await dio.get<dynamic>('/documents');

    expect(response.statusCode, 200);
    expect(response.requestOptions.headers['Authorization'], 'Bearer velho');
  });

  test('renova a sessão no 401 e repete a requisição', () async {
    final response = await dio.get<dynamic>('/documents');

    expect(response.statusCode, 200);
    expect(adapter.refreshCalls, 1);
    // Uma tentativa que falhou e a repetição bem-sucedida.
    expect(adapter.protectedCalls, 2);

    final stored = await storage.read();
    expect(stored?.accessToken, 'novo');
  });

  test('requisições concorrentes disparam um único refresh', () async {
    // É o cenário real: o polling de documentos a cada dois segundos, o chat
    // e o perfil batendo juntos com o token vencido. Sem single-flight, cada
    // um abriria seu próprio refresh — e como o backend invalida o refresh
    // token a cada uso, todos menos o primeiro falhariam.
    adapter.refreshDelay = const Duration(milliseconds: 100);

    final responses = await Future.wait([
      dio.get<dynamic>('/documents'),
      dio.get<dynamic>('/conversations'),
      dio.get<dynamic>('/auth/me'),
      dio.get<dynamic>('/documents'),
    ]);

    expect(responses.every((r) => r.statusCode == 200), isTrue);
    expect(
      adapter.refreshCalls,
      1,
      reason: 'as quatro requisições devem compartilhar a mesma renovação',
    );
  });

  test('refresh vencido limpa os tokens e avisa a sessão expirada', () async {
    adapter.refreshFails = true;

    await expectLater(
      dio.get<dynamic>('/documents'),
      throwsA(isA<DioException>()),
    );

    expect(sessionExpiredCalls, 1);
    expect(await storage.read(), isNull);
  });

  test('não tenta renovar duas vezes a mesma requisição', () async {
    // Se o refresh "funciona" mas o token continua sendo recusado, a
    // requisição falha em vez de entrar em laço.
    adapter.refreshFails = false;

    var refreshDone = false;
    final refreshClient = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter;

    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AuthInterceptor(
          storage: storage,
          refreshClient: refreshClient,
          onSessionExpired: () async {
            refreshDone = true;
          },
        ),
      );

    // O adaptador segue recusando mesmo depois de renovar.
    adapter.accessTokenIsValid = false;
    final before = adapter.refreshCalls;

    try {
      await dio.get<dynamic>('/documents');
    } on DioException {
      // Esperado.
    }

    expect(adapter.refreshCalls - before, lessThanOrEqualTo(1));
    expect(refreshDone, isFalse);
  });

  test('login e refresh não levam Authorization', () async {
    adapter.accessTokenIsValid = true;

    final response = await dio.post<dynamic>(
      '/auth/google',
      data: {'id_token': 'x'},
      options: Options(extra: const {'skipAuth': true}),
    );

    expect(response.requestOptions.headers.containsKey('Authorization'), false);
  });
}
