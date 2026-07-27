import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client.dart';
import '../../../core/config/app_config.dart';
import '../datasources/documents_datasource.dart';
import '../datasources/documents_http_datasource.dart';
import '../datasources/documents_mock_datasource.dart';
import '../models/document.dart';
import '../repositories/documents_repository.dart';

part 'documents_providers.g.dart';

@Riverpod(keepAlive: true)
DocumentsDatasource documentsDatasource(Ref ref) {
  if (AppConfig.useMocks) {
    final datasource = DocumentsMockDatasource();
    ref.onDispose(datasource.dispose);
    return datasource;
  }

  return DocumentsHttpDatasource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
DocumentsRepository documentsRepository(Ref ref) =>
    DocumentsRepository(ref.watch(documentsDatasourceProvider));

@riverpod
Future<Document> documentById(Ref ref, String id) =>
    ref.watch(documentsRepositoryProvider).byId(id);

@riverpod
Future<String> documentDownloadUrl(Ref ref, String id) =>
    ref.watch(documentsRepositoryProvider).downloadUrl(id);
