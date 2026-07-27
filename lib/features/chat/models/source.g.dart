// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Source _$SourceFromJson(Map<String, dynamic> json) => _Source(
  documentId: json['document_id'] as String,
  documentTitle: json['document_title'] as String,
  page: (json['page'] as num).toInt(),
  score: (json['score'] as num).toDouble(),
  excerpt: json['excerpt'] as String,
);

Map<String, dynamic> _$SourceToJson(_Source instance) => <String, dynamic>{
  'document_id': instance.documentId,
  'document_title': instance.documentTitle,
  'page': instance.page,
  'score': instance.score,
  'excerpt': instance.excerpt,
};
