import '../../../core/models/user.dart';
import '../../../core/services/token_storage.dart';
import '../datasources/auth_datasource.dart';

class AuthRepository {
  const AuthRepository(this._datasource, this._storage);

  final AuthDatasource _datasource;
  final TokenStorage _storage;

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
