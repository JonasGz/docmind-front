// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lista de documentos do usuário, com polling enquanto houver documento em
/// processamento.
///
/// É global (`keepAlive`), e não atrelado à tela: o subtítulo do chat
/// ("N documentos no contexto") consome o mesmo estado, e um upload iniciado
/// na aba Documentos precisa continuar sendo acompanhado depois que o usuário
/// troca de aba.

@ProviderFor(DocumentsViewModel)
final documentsViewModelProvider = DocumentsViewModelProvider._();

/// Lista de documentos do usuário, com polling enquanto houver documento em
/// processamento.
///
/// É global (`keepAlive`), e não atrelado à tela: o subtítulo do chat
/// ("N documentos no contexto") consome o mesmo estado, e um upload iniciado
/// na aba Documentos precisa continuar sendo acompanhado depois que o usuário
/// troca de aba.
final class DocumentsViewModelProvider
    extends $AsyncNotifierProvider<DocumentsViewModel, List<Document>> {
  /// Lista de documentos do usuário, com polling enquanto houver documento em
  /// processamento.
  ///
  /// É global (`keepAlive`), e não atrelado à tela: o subtítulo do chat
  /// ("N documentos no contexto") consome o mesmo estado, e um upload iniciado
  /// na aba Documentos precisa continuar sendo acompanhado depois que o usuário
  /// troca de aba.
  DocumentsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsViewModelHash();

  @$internal
  @override
  DocumentsViewModel create() => DocumentsViewModel();
}

String _$documentsViewModelHash() =>
    r'948d41b9403c0d81ed107fa5c6093a02c96bbb54';

/// Lista de documentos do usuário, com polling enquanto houver documento em
/// processamento.
///
/// É global (`keepAlive`), e não atrelado à tela: o subtítulo do chat
/// ("N documentos no contexto") consome o mesmo estado, e um upload iniciado
/// na aba Documentos precisa continuar sendo acompanhado depois que o usuário
/// troca de aba.

abstract class _$DocumentsViewModel extends $AsyncNotifier<List<Document>> {
  FutureOr<List<Document>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Document>>, List<Document>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Document>>, List<Document>>,
              AsyncValue<List<Document>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Quantidade de documentos indexados — o que o chat pode citar.

@ProviderFor(indexedDocumentCount)
final indexedDocumentCountProvider = IndexedDocumentCountProvider._();

/// Quantidade de documentos indexados — o que o chat pode citar.

final class IndexedDocumentCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Quantidade de documentos indexados — o que o chat pode citar.
  IndexedDocumentCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'indexedDocumentCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$indexedDocumentCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return indexedDocumentCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$indexedDocumentCountHash() =>
    r'bc2085407aa05002b0f2cfe0f7212bf9b696934c';
