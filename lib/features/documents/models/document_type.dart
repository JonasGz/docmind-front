import 'package:json_annotation/json_annotation.dart';

/// Espelha `DocumentType` do backend (`app/models/document.py`).
///
/// É o tipo classificado automaticamente na ingestão. O backend também
/// devolve `raw_doc_type` com a classificação original em texto livre, útil
/// quando cai em `outro`.
@JsonEnum(valueField: 'wire')
enum DocumentType {
  norma('norma', 'Norma'),
  jurisprudencia('jurisprudencia', 'Jurisprudência'),
  sumula('sumula', 'Súmula'),
  contrato('contrato', 'Contrato'),
  parecer('parecer', 'Parecer'),
  peticao('peticao', 'Petição'),
  comunicacao('comunicacao', 'Comunicação'),
  edital('edital', 'Edital'),
  outro('outro', 'Outro'),

  /// Tipo não reconhecido — o backend pode ganhar categorias novas.
  unknown('unknown', 'Outro');

  const DocumentType(this.wire, this.label);

  final String wire;

  /// Rótulo em português para exibição.
  final String label;

  static DocumentType? fromWire(String? value) {
    if (value == null) return null;
    return DocumentType.values.firstWhere(
      (type) => type.wire == value,
      orElse: () => DocumentType.unknown,
    );
  }
}
