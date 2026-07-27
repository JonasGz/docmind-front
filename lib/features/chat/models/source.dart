import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';
part 'source.g.dart';

/// Espelha `Source` do backend (`app/schemas/conversation.py`).
///
/// É a citação que sustenta uma resposta: qual documento, qual página, com
/// que similaridade e o trecho recuperado. No domínio jurídico, uma resposta
/// sem fonte auditável é pior que nenhuma resposta — por isso o `score` e o
/// `excerpt` ficam disponíveis ao usuário, não apenas o nome do documento.
@freezed
abstract class Source with _$Source {
  const factory Source({
    required String documentId,
    required String documentTitle,

    /// Página do PDF, base 1 — usada para abrir o visualizador no ponto
    /// exato da citação.
    required int page,

    /// Similaridade do cosseno, 0–1. O backend só retorna trechos acima de
    /// `SIMILARITY_THRESHOLD` (0,50).
    required double score,

    required String excerpt,
  }) = _Source;

  const Source._();

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  /// Rótulo do chip no chat: "Contrato_Locacao.pdf · pág. 4".
  String get label => '$documentTitle · pág. $page';

  /// Score em percentual, para o sheet de detalhe da fonte.
  String get scoreLabel => '${(score * 100).round()}%';
}
