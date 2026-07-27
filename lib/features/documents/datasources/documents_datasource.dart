import 'dart:typed_data';

import '../models/document.dart';

/// Superfície de dados de documentos.
///
/// Este é **o** ponto de troca entre mock e HTTP (Fase 8): existem
/// `DocumentsMockDatasource` e `DocumentsHttpDatasource` com esta mesma
/// superfície, e um provider decide qual injetar. O repositório e o
/// ViewModel nunca sabem qual está em uso.
abstract interface class DocumentsDatasource {
  /// `GET /documents` — sem paginação no backend, devolve tudo.
  Future<List<Document>> list();

  /// `GET /documents/{id}`.
  Future<Document> byId(String id);

  /// `POST /documents` — responde 202 com o documento em `uploaded`; o
  /// processamento segue assíncrono. Só aceita `application/pdf`, senão 415.
  Future<Document> upload({
    required String filename,
    required Uint8List bytes,
  });

  /// `DELETE /documents/{id}` — 204.
  Future<void> delete(String id);

  /// `GET /documents/{id}/download` — URL assinada e temporária, usada pelo
  /// visualizador de PDF.
  Future<String> downloadUrl(String id);
}
