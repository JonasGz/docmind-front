import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';

part 'google_sign_in_service.g.dart';

/// Obtém o `id_token` do Google, que o backend troca por tokens da API.
abstract interface class GoogleSignInService {
  /// Devolve o `id_token`, ou nulo se o usuário cancelou.
  Future<String?> signIn();

  Future<void> signOut();
}

class RealGoogleSignInService implements GoogleSignInService {
  RealGoogleSignInService();

  var _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    // O `serverClientId` precisa ser o Client ID **web**, não o da
    // plataforma: é a audiência que o backend valida. Apontar para o Client
    // ID do iOS ou do Android faz o backend rejeitar o token, e a mensagem de
    // erro não indica a causa — é a falha mais comum desta integração.
    await GoogleSignIn.instance.initialize(
      serverClientId: AppConfig.googleWebClientId,
    );
    _initialized = true;
  }

  @override
  Future<String?> signIn() async {
    await _ensureInitialized();

    final account = await GoogleSignIn.instance.authenticate(
      scopeHint: const ['email', 'profile'],
    );

    return account.authentication.idToken;
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();
  }
}

/// Sem Client IDs configurados não há como falar com o Google; este devolve
/// um token de fachada para rodar o aplicativo com mocks.
class MockGoogleSignInService implements GoogleSignInService {
  @override
  Future<String?> signIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return 'mock-id-token';
  }

  @override
  Future<void> signOut() async {}
}

@Riverpod(keepAlive: true)
GoogleSignInService googleSignInService(Ref ref) =>
    AppConfig.useMocks ? MockGoogleSignInService() : RealGoogleSignInService();
