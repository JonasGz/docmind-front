// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// O ponto de troca: a flag decide mock ou HTTP, e nada acima disto muda.
///
/// Também é a seam de teste — os testes substituem este provider via
/// `ProviderScope(overrides:)` para injetar um datasource controlado.

@ProviderFor(documentsDatasource)
final documentsDatasourceProvider = DocumentsDatasourceProvider._();

/// O ponto de troca: a flag decide mock ou HTTP, e nada acima disto muda.
///
/// Também é a seam de teste — os testes substituem este provider via
/// `ProviderScope(overrides:)` para injetar um datasource controlado.

final class DocumentsDatasourceProvider
    extends
        $FunctionalProvider<
          DocumentsDatasource,
          DocumentsDatasource,
          DocumentsDatasource
        >
    with $Provider<DocumentsDatasource> {
  /// O ponto de troca: a flag decide mock ou HTTP, e nada acima disto muda.
  ///
  /// Também é a seam de teste — os testes substituem este provider via
  /// `ProviderScope(overrides:)` para injetar um datasource controlado.
  DocumentsDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsDatasourceHash();

  @$internal
  @override
  $ProviderElement<DocumentsDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentsDatasource create(Ref ref) {
    return documentsDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentsDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentsDatasource>(value),
    );
  }
}

String _$documentsDatasourceHash() =>
    r'951241dd40a6df49709d7c56a5cfa1f9cc88d04e';

@ProviderFor(documentsRepository)
final documentsRepositoryProvider = DocumentsRepositoryProvider._();

final class DocumentsRepositoryProvider
    extends
        $FunctionalProvider<
          DocumentsRepository,
          DocumentsRepository,
          DocumentsRepository
        >
    with $Provider<DocumentsRepository> {
  DocumentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DocumentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentsRepository create(Ref ref) {
    return documentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentsRepository>(value),
    );
  }
}

String _$documentsRepositoryHash() =>
    r'463fca136bbf3b3fdc96a48878ae7ad010949e32';
