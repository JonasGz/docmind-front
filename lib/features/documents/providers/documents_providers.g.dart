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
    r'181850e117e49b8cc1080a2c71d324393e736103';

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

/// Documento avulso, para o visualizador que recebe só o id na rota.

@ProviderFor(documentById)
final documentByIdProvider = DocumentByIdFamily._();

/// Documento avulso, para o visualizador que recebe só o id na rota.

final class DocumentByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Document>, Document, FutureOr<Document>>
    with $FutureModifier<Document>, $FutureProvider<Document> {
  /// Documento avulso, para o visualizador que recebe só o id na rota.
  DocumentByIdProvider._({
    required DocumentByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentByIdHash();

  @override
  String toString() {
    return r'documentByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Document> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Document> create(Ref ref) {
    final argument = this.argument as String;
    return documentById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentByIdHash() => r'538be04aaa819bd37c988bb24724afed3336463d';

/// Documento avulso, para o visualizador que recebe só o id na rota.

final class DocumentByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Document>, String> {
  DocumentByIdFamily._()
    : super(
        retry: null,
        name: r'documentByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Documento avulso, para o visualizador que recebe só o id na rota.

  DocumentByIdProvider call(String id) =>
      DocumentByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'documentByIdProvider';
}

/// URL assinada e temporária do PDF.

@ProviderFor(documentDownloadUrl)
final documentDownloadUrlProvider = DocumentDownloadUrlFamily._();

/// URL assinada e temporária do PDF.

final class DocumentDownloadUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// URL assinada e temporária do PDF.
  DocumentDownloadUrlProvider._({
    required DocumentDownloadUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentDownloadUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentDownloadUrlHash();

  @override
  String toString() {
    return r'documentDownloadUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return documentDownloadUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentDownloadUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentDownloadUrlHash() =>
    r'353ac217626be030ac1c40918187a6421cf92b8a';

/// URL assinada e temporária do PDF.

final class DocumentDownloadUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  DocumentDownloadUrlFamily._()
    : super(
        retry: null,
        name: r'documentDownloadUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// URL assinada e temporária do PDF.

  DocumentDownloadUrlProvider call(String id) =>
      DocumentDownloadUrlProvider._(argument: id, from: this);

  @override
  String toString() => r'documentDownloadUrlProvider';
}
