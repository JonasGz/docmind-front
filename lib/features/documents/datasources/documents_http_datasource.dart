import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../models/document.dart';
import 'documents_datasource.dart';

class DocumentsHttpDatasource implements DocumentsDatasource {
  const DocumentsHttpDatasource(this._dio);

  final Dio _dio;

  @override
  Future<List<Document>> list() async {
    final response = await _dio.get<Map<String, dynamic>>('/documents');
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((item) => Document.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Document> byId(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/documents/$id');
    return Document.fromJson(response.data!);
  }

  @override
  Future<Document> upload({
    required String filename,
    required Uint8List bytes,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        // O backend valida o content-type e responde 415 para qualquer coisa
        // que não seja PDF.
        contentType: DioMediaType('application', 'pdf'),
      ),
    });

    final response = await _dio.post<Map<String, dynamic>>(
      '/documents',
      data: form,
    );
    return Document.fromJson(response.data!);
  }

  @override
  Future<void> delete(String id) => _dio.delete<void>('/documents/$id');

  @override
  Future<String> downloadUrl(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/documents/$id/download',
    );
    return response.data!['url'] as String;
  }
}
