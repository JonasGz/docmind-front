import 'package:json_annotation/json_annotation.dart';

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

  unknown('unknown', 'Outro');

  const DocumentType(this.wire, this.label);

  final String wire;

  final String label;

  static DocumentType? fromWire(String? value) {
    if (value == null) return null;
    return DocumentType.values.firstWhere(
      (type) => type.wire == value,
      orElse: () => DocumentType.unknown,
    );
  }
}
