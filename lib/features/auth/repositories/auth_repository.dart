import '../../../core/models/user.dart';
import '../../../core/services/token_storage.dart';
import '../datasources/auth_datasource.dart';

class AuthRepository {
  const AuthRepository(this._datasource, this._storage);

  final AuthDatasource _datasource;
  final TokenStorage _storage;

  /// Recupera a sessão guardada ao abrir o aplicativo. Se os tokens
  /// existirem mas não valerem mais, limpa e devolve nulo em vez de
  /// propagar erro — a tela de login é a resposta certa nesse caso.
  Future<User?> restoreSession() async {
    final tokens = await _storage.read();
    if (tokens == null) return null;

    try {
      return await _datasource.me();
    } on Object {
      await _storage.clear();
      return null;
    }
  }

  Future<User> signInWithGoogle(String idToken) async {
    final tokens = await _datasource.signInWithGoogle(idToken);
    await _storage.write(tokens);
    return _datasource.me();
  }

  Future<void> signOut() => _storage.clear();
}
