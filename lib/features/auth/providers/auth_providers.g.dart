// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authDatasource)
final authDatasourceProvider = AuthDatasourceProvider._();

final class AuthDatasourceProvider
    extends $FunctionalProvider<AuthDatasource, AuthDatasource, AuthDatasource>
    with $Provider<AuthDatasource> {
  AuthDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDatasourceHash();

  @$internal
  @override
  $ProviderElement<AuthDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthDatasource create(Ref ref) {
    return authDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthDatasource>(value),
    );
  }
}

String _$authDatasourceHash() => r'1aa09f682886c47c24539f568e59b6a2b854760e';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'af9098b983f695b83968eb8360c2a4e0caa14013';

/// Sessão atual. Nulo significa deslogado.

@ProviderFor(AuthViewModel)
final authViewModelProvider = AuthViewModelProvider._();

/// Sessão atual. Nulo significa deslogado.
final class AuthViewModelProvider
    extends $AsyncNotifierProvider<AuthViewModel, User?> {
  /// Sessão atual. Nulo significa deslogado.
  AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();
}

String _$authViewModelHash() => r'fb67bb8b5dceaa8ad9054906518286488bb0ca41';

/// Sessão atual. Nulo significa deslogado.

abstract class _$AuthViewModel extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Usuário logado, para as telas que só precisam do perfil.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Usuário logado, para as telas que só precisam do perfil.

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<User?>,
          AsyncValue<User?>,
          AsyncValue<User?>
        >
    with $Provider<AsyncValue<User?>> {
  /// Usuário logado, para as telas que só precisam do perfil.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<User?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<User?> create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<User?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<User?>>(value),
    );
  }
}

String _$currentUserHash() => r'70423d67154ea14eed74089e115314f8a2e7677d';
