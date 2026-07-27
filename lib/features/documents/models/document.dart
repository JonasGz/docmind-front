import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_status.dart';
import 'document_type.dart';

part 'document.freezed.dart';
part 'document.g.dart';

@freezed
abstract class Document with _$Document {
  const factory Document({
    required String id,
    required String filename,

    @JsonKey(unknownEnumValue: DocumentStatus.unknown)
    required DocumentStatus status,

    required String? title,
    @JsonKey(unknownEnumValue: DocumentType.unknown)
    required DocumentType? docType,

    required String? rawDocType,

    required List<String>? identifiers,

    required int? pageCount,
    required int? chunkCount,

    required String? errorMessage,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Document;

  const Document._();

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  String get displayName => title ?? filename;
}
