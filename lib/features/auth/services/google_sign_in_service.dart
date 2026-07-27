import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';

part 'google_sign_in_service.g.dart';

abstract interface class GoogleSignInService {
  Future<String?> signIn();

  Future<void> signOut();
}

class RealGoogleSignInService implements GoogleSignInService {
  RealGoogleSignInService();

  var _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

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
