import '../../../core/models/token_pair.dart';
import '../../../core/models/user.dart';

/// Superfície de autenticação. Ponto de troca mock/HTTP, como nas demais
/// features.
abstract interface class AuthDatasource {
  /// `POST /auth/google` — troca o `id_token` do Google por tokens da API.
  Future<TokenPair> signInWithGoogle(String idToken);

  /// `POST /auth/refresh`.
  Future<TokenPair> refresh(String refreshToken);

  /// `GET /auth/me`.
  Future<User> me();
}
