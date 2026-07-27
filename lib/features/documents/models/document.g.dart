// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Document _$DocumentFromJson(Map<String, dynamic> json) => _Document(
  id: json['id'] as String,
  filename: json['filename'] as String,
  status: $enumDecode(
    _$DocumentStatusEnumMap,
    json['status'],
    unknownValue: DocumentStatus.unknown,
  ),
  title: json['title'] as String?,
  docType: $enumDecodeNullable(
    _$DocumentTypeEnumMap,
    json['doc_type'],
    unknownValue: DocumentType.unknown,
  ),
  rawDocType: json['raw_doc_type'] as String?,
  identifiers: (json['identifiers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  pageCount: (json['page_count'] as num?)?.toInt(),
  chunkCount: (json['chunk_count'] as num?)?.toInt(),
  errorMessage: json['error_message'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$DocumentToJson(_Document instance) => <String, dynamic>{
  'id': instance.id,
  'filename': instance.filename,
  'status': _$DocumentStatusEnumMap[instance.status]!,
  'title': instance.title,
  'doc_type': _$DocumentTypeEnumMap[instance.docType],
  'raw_doc_type': instance.rawDocType,
  'identifiers': instance.identifiers,
  'page_count': instance.pageCount,
  'chunk_count': instance.chunkCount,
  'error_message': instance.errorMessage,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.uploaded: 'uploaded',
  DocumentStatus.processing: 'processing',
  DocumentStatus.indexed: 'indexed',
  DocumentStatus.failed: 'failed',
  DocumentStatus.unknown: 'unknown',
};

const _$DocumentTypeEnumMap = {
  DocumentType.norma: 'norma',
  DocumentType.jurisprudencia: 'jurisprudencia',
  DocumentType.sumula: 'sumula',
  DocumentType.contrato: 'contrato',
  DocumentType.parecer: 'parecer',
  DocumentType.peticao: 'peticao',
  DocumentType.comunicacao: 'comunicacao',
  DocumentType.edital: 'edital',
  DocumentType.outro: 'outro',
  DocumentType.unknown: 'unknown',
};
