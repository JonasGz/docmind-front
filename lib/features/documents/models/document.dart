import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_status.dart';
import 'document_type.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// Espelha `DocumentResponse` do backend (`app/schemas/document.py`).
///
/// Quase tudo é anulável porque o pipeline preenche os campos aos poucos:
/// logo após o upload existem apenas `id`, `filename`, `status` e as datas.
/// Título, tipo e contagens só aparecem depois da indexação.
@freezed
abstract class Document with _$Document {
  const factory Document({
    required String id,
    required String filename,

    /// Serializado com `unknownEnumValue` para que um status novo no backend
    /// não lance exceção no parse.
    @JsonKey(unknownEnumValue: DocumentStatus.unknown)
    required DocumentStatus status,

    required String? title,
    @JsonKey(unknownEnumValue: DocumentType.unknown)
    required DocumentType? docType,

    /// Classificação original em texto livre, quando `docType` é `outro`.
    required String? rawDocType,

    /// Números de lei, processo, súmula extraídos do documento.
    required List<String>? identifiers,

    required int? pageCount,
    required int? chunkCount,

    /// Preenchido apenas quando `status` é `failed`.
    required String? errorMessage,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Document;

  const Document._();

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  /// Nome a exibir: o título extraído do conteúdo é mais útil que o nome do
  /// arquivo, mas nem sempre existe.
  String get displayName => title ?? filename;
}
