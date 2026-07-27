import 'dart:typed_data';

import '../models/document.dart';

abstract interface class DocumentsDatasource {
  Future<List<Document>> list();

  Future<Document> byId(String id);

  Future<Document> upload({required String filename, required Uint8List bytes});

  Future<void> delete(String id);

  Future<String> downloadUrl(String id);
}
