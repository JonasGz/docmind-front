import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../core/models/user.dart';
import '../../../core/services/token_storage_provider.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/auth_http_datasource.dart';
import '../datasources/auth_mock_datasource.dart';
import '../repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthDatasource authDatasource(Ref ref) {
  if (AppConfig.useMocks) return AuthMockDatasource();

  return AuthHttpDatasource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository(
  ref.watch(authDatasourceProvider),
  ref.watch(tokenStorageProvider),
);

/// Sessão atual. Nulo significa deslogado.
@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<User?> build() => ref.read(authRepositoryProvider).restoreSession();

  Future<void> signInWithGoogle(String idToken) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signInWithGoogle(idToken),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}

/// Usuário logado, para as telas que só precisam do perfil.
@Riverpod(keepAlive: true)
AsyncValue<User?> currentUser(Ref ref) => ref.watch(authViewModelProvider);
