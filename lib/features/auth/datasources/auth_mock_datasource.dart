import '../../../core/models/token_pair.dart';
import '../../../core/models/user.dart';
import 'auth_datasource.dart';

class AuthMockDatasource implements AuthDatasource {
  AuthMockDatasource({this.latency = const Duration(milliseconds: 400)});

  final Duration latency;

  @override
  Future<TokenPair> signInWithGoogle(String idToken) async {
    await Future<void>.delayed(latency);
    return const TokenPair(
      accessToken: 'mock-access',
      refreshToken: 'mock-refresh',
    );
  }

  @override
  Future<TokenPair> refresh(String refreshToken) async {
    await Future<void>.delayed(latency);
    return const TokenPair(
      accessToken: 'mock-access-renovado',
      refreshToken: 'mock-refresh',
    );
  }

  @override
  Future<User> me() async {
    await Future<void>.delayed(latency);
    return User(
      id: 'user-mock',
      email: 'marina.barros@gmail.com',
      name: 'Marina Barros',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    );
  }
}
