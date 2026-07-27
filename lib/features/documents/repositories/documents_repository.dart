import 'dart:typed_data';

import '../datasources/documents_datasource.dart';
import '../models/document.dart';

/// Fonte única de verdade para documentos.
///
/// Classe concreta, sem interface abstrata: existe uma implementação só, e a
/// variação de mock/HTTP acontece um nível abaixo, no datasource.
class DocumentsRepository {
  const DocumentsRepository(this._datasource);

  final DocumentsDatasource _datasource;

  Future<List<Document>> list() => _datasource.list();

  Future<Document> byId(String id) => _datasource.byId(id);

  Future<Document> upload({
    required String filename,
    required Uint8List bytes,
  }) => _datasource.upload(filename: filename, bytes: bytes);

  Future<void> delete(String id) => _datasource.delete(id);

  Future<String> downloadUrl(String id) => _datasource.downloadUrl(id);
}
