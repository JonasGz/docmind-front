// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ponto de troca mock/HTTP e seam de teste, como em documentos.

@ProviderFor(conversationsDatasource)
final conversationsDatasourceProvider = ConversationsDatasourceProvider._();

/// Ponto de troca mock/HTTP e seam de teste, como em documentos.

final class ConversationsDatasourceProvider
    extends
        $FunctionalProvider<
          ConversationsDatasource,
          ConversationsDatasource,
          ConversationsDatasource
        >
    with $Provider<ConversationsDatasource> {
  /// Ponto de troca mock/HTTP e seam de teste, como em documentos.
  ConversationsDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsDatasourceHash();

  @$internal
  @override
  $ProviderElement<ConversationsDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConversationsDatasource create(Ref ref) {
    return conversationsDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationsDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationsDatasource>(value),
    );
  }
}

String _$conversationsDatasourceHash() =>
    r'89ed3d8ae98aacde86d3184f7362a07ac7bfe0d8';

@ProviderFor(conversationsRepository)
final conversationsRepositoryProvider = ConversationsRepositoryProvider._();

final class ConversationsRepositoryProvider
    extends
        $FunctionalProvider<
          ConversationsRepository,
          ConversationsRepository,
          ConversationsRepository
        >
    with $Provider<ConversationsRepository> {
  ConversationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConversationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConversationsRepository create(Ref ref) {
    return conversationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationsRepository>(value),
    );
  }
}

String _$conversationsRepositoryHash() =>
    r'7242cd36bb3a5b49f52c773043d3ed1781bb5687';
