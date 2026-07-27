import 'package:docmind/core/models/token_pair.dart';
import 'package:docmind/core/models/user.dart';
import 'package:docmind/core/services/token_storage.dart';
import 'package:docmind/features/auth/datasources/auth_datasource.dart';
import 'package:docmind/features/auth/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthDatasource implements AuthDatasource {
  _FakeAuthDatasource();

  Object? meError;
  int meCalls = 0;

  @override
  Future<TokenPair> signInWithGoogle(String idToken) async =>
      const TokenPair(accessToken: 'a', refreshToken: 'r');

  @override
  Future<TokenPair> refresh(String refreshToken) async =>
      const TokenPair(accessToken: 'a2', refreshToken: 'r2');

  @override
  Future<User> me() async {
    meCalls++;
    if (meError case final error?) throw error;
    return User(
      id: 'u1',
      email: 'marina.barros@gmail.com',
      name: 'Marina Barros',
      createdAt: DateTime(2026),
    );
  }
}

void main() {
  test('sem tokens guardados a sessão começa vazia', () async {
    final repository = AuthRepository(
      _FakeAuthDatasource(),
      InMemoryTokenStorage(),
    );

    expect(await repository.restoreSession(), isNull);
  });

  test('com tokens válidos restaura o usuário', () async {
    final storage = InMemoryTokenStorage()
      ..write(const TokenPair(accessToken: 'a', refreshToken: 'r'));

    final repository = AuthRepository(_FakeAuthDatasource(), storage);
    final user = await repository.restoreSession();

    expect(user?.displayName, 'Marina Barros');
    expect(user?.initials, 'MB');
  });

  test('tokens inválidos são descartados em vez de virar erro', () async {
    // O usuário deve cair na tela de login, não numa tela de erro.
    final storage = InMemoryTokenStorage();
    await storage.write(
      const TokenPair(accessToken: 'velho', refreshToken: 'velho'),
    );

    final datasource = _FakeAuthDatasource()..meError = StateError('401');
    final repository = AuthRepository(datasource, storage);

    expect(await repository.restoreSession(), isNull);
    expect(
      await storage.read(),
      isNull,
      reason: 'tokens que não valem mais não podem ficar guardados',
    );
  });

  test('login guarda os tokens e devolve o perfil', () async {
    final storage = InMemoryTokenStorage();
    final repository = AuthRepository(_FakeAuthDatasource(), storage);

    final user = await repository.signInWithGoogle('id-token');

    expect(user.email, 'marina.barros@gmail.com');
    expect((await storage.read())?.accessToken, 'a');
  });

  test('sair limpa os tokens', () async {
    final storage = InMemoryTokenStorage();
    await storage.write(const TokenPair(accessToken: 'a', refreshToken: 'r'));

    await AuthRepository(_FakeAuthDatasource(), storage).signOut();

    expect(await storage.read(), isNull);
  });
}
