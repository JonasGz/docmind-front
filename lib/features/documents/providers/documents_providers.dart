import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_config.dart';
import '../datasources/documents_datasource.dart';
import '../datasources/documents_mock_datasource.dart';
import '../models/document.dart';
import '../repositories/documents_repository.dart';

part 'documents_providers.g.dart';

/// O ponto de troca: a flag decide mock ou HTTP, e nada acima disto muda.
///
/// Também é a seam de teste — os testes substituem este provider via
/// `ProviderScope(overrides:)` para injetar um datasource controlado.
@Riverpod(keepAlive: true)
DocumentsDatasource documentsDatasource(Ref ref) {
  if (AppConfig.useMocks) {
    final datasource = DocumentsMockDatasource();
    ref.onDispose(datasource.dispose);
    return datasource;
  }

  // Fase 8: DocumentsHttpDatasource(ref.watch(dioProvider)).
  throw UnimplementedError(
    'O datasource HTTP de documentos chega na Fase 8. '
    'Rode com --dart-define=USE_MOCKS=true até lá.',
  );
}

@Riverpod(keepAlive: true)
DocumentsRepository documentsRepository(Ref ref) =>
    DocumentsRepository(ref.watch(documentsDatasourceProvider));

/// Documento avulso, para o visualizador que recebe só o id na rota.
@riverpod
Future<Document> documentById(Ref ref, String id) =>
    ref.watch(documentsRepositoryProvider).byId(id);

/// URL assinada e temporária do PDF.
@riverpod
Future<String> documentDownloadUrl(Ref ref, String id) =>
    ref.watch(documentsRepositoryProvider).downloadUrl(id);
