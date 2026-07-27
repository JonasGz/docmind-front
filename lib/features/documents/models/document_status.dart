import 'package:json_annotation/json_annotation.dart';

/// Espelha `DocumentStatus` do backend (`app/models/document.py`).
///
/// O pipeline de ingestão é assíncrono: o upload responde 202 com `uploaded`,
/// e o documento passa por `processing` até chegar a `indexed` ou `failed`.
/// Só em `indexed` ele participa das buscas do chat.
@JsonEnum(valueField: 'wire')
enum DocumentStatus {
  uploaded('uploaded'),
  processing('processing'),
  indexed('indexed'),
  failed('failed'),

  /// Valor não reconhecido. Um status novo no backend não pode derrubar a
  /// tela de documentos do usuário.
  unknown('unknown');

  const DocumentStatus(this.wire);

  final String wire;

  static DocumentStatus fromWire(String? value) {
    return DocumentStatus.values.firstWhere(
      (status) => status.wire == value,
      orElse: () => DocumentStatus.unknown,
    );
  }

  /// Documento ainda em processamento — a tela mostra progresso e o polling
  /// continua ativo.
  bool get isPending =>
      this == DocumentStatus.uploaded || this == DocumentStatus.processing;

  bool get isReady => this == DocumentStatus.indexed;

  bool get hasFailed => this == DocumentStatus.failed;
}
