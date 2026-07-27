import '../../../core/models/token_pair.dart';
import '../../../core/models/user.dart';

abstract interface class AuthDatasource {
  Future<TokenPair> signInWithGoogle(String idToken);

  Future<TokenPair> refresh(String refreshToken);

  Future<User> me();
}
