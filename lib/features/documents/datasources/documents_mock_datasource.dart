import 'dart:async';
import 'dart:typed_data';

import '../models/document.dart';
import '../models/document_status.dart';
import '../models/document_type.dart';
import 'documents_datasource.dart';

/// Mock em memória do backend de documentos.
///
/// Não é descartado na Fase 8: permanece atrás de uma flag para rodar o
/// aplicativo sem backend e para os testes de widget.
///
/// Reproduz o comportamento que mais afeta a interface: o upload responde
/// imediatamente com `uploaded` e o documento só chega a `indexed` depois de
/// um tempo, exatamente como o pipeline real — é isso que exercita o polling.
class DocumentsMockDatasource implements DocumentsDatasource {
  DocumentsMockDatasource({
    this.latency = const Duration(milliseconds: 400),
    this.processingTime = const Duration(seconds: 6),
  }) : _documents = List.of(_seed);

  /// Atraso artificial de rede, para que os estados de carregamento apareçam.
  final Duration latency;

  /// Tempo até um documento recém-enviado ficar indexado.
  final Duration processingTime;

  final List<Document> _documents;
  final _timers = <String, Timer>{};

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  @override
  Future<List<Document>> list() async {
    await Future<void>.delayed(latency);
    // O backend ordena por data de criação, mais recente primeiro.
    return List.unmodifiable(
      _documents.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  @override
  Future<Document> byId(String id) async {
    await Future<void>.delayed(latency);
    final document = _documents.where((d) => d.id == id).firstOrNull;
    if (document == null) {
      throw StateError('documento $id não encontrado');
    }
    return document;
  }

  @override
  Future<Document> upload({
    required String filename,
    required Uint8List bytes,
  }) async {
    await Future<void>.delayed(latency);

    final now = DateTime.now();
    final document = Document(
      id: 'mock-${now.microsecondsSinceEpoch}',
      filename: filename,
      status: DocumentStatus.uploaded,
      title: null,
      docType: null,
      rawDocType: null,
      identifiers: null,
      pageCount: null,
      chunkCount: null,
      errorMessage: null,
      createdAt: now,
      updatedAt: now,
    );

    _documents.add(document);
    _scheduleProcessing(document.id);
    return document;
  }

  @override
  Future<void> delete(String id) async {
    await Future<void>.delayed(latency);
    _timers.remove(id)?.cancel();
    _documents.removeWhere((d) => d.id == id);
  }

  @override
  Future<String> downloadUrl(String id) async {
    await Future<void>.delayed(latency);
    // Sem backend não há PDF real; a Fase 7 trata a ausência de arquivo.
    return 'mock://documents/$id.pdf';
  }

  /// Simula o pipeline: `uploaded` → `processing` → `indexed`.
  void _scheduleProcessing(String id) {
    final half = processingTime ~/ 2;

    _timers[id] = Timer(half, () {
      _patch(id, (d) => d.copyWith(status: DocumentStatus.processing));

      _timers[id] = Timer(half, () {
        _patch(
          id,
          (d) => d.copyWith(
            status: DocumentStatus.indexed,
            title: d.filename.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), ''),
            docType: DocumentType.outro,
            pageCount: 8,
            chunkCount: 24,
          ),
        );
        _timers.remove(id);
      });
    });
  }

  void _patch(String id, Document Function(Document) update) {
    final index = _documents.indexWhere((d) => d.id == id);
    if (index == -1) return;
    _documents[index] = update(
      _documents[index],
    ).copyWith(updatedAt: DateTime.now());
  }
}

/// Documentos iniciais — nomes e tipos coerentes com o domínio jurídico, em
/// vez dos genéricos do desenho.
final _seed = <Document>[
  Document(
    id: 'doc-contrato-locacao',
    filename: 'Contrato_Locacao_Comercial.pdf',
    status: DocumentStatus.indexed,
    title: 'Contrato de Locação Comercial',
    docType: DocumentType.contrato,
    rawDocType: 'contrato de locação comercial',
    identifiers: const ['CNJ 0001234-56.2026.8.11.0001'],
    pageCount: 12,
    chunkCount: 48,
    errorMessage: null,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Document(
    id: 'doc-parecer',
    filename: 'Parecer_Juridico_Licitacao.pdf',
    status: DocumentStatus.indexed,
    title: 'Parecer Jurídico — Pregão Eletrônico 014/2026',
    docType: DocumentType.parecer,
    rawDocType: 'parecer jurídico',
    identifiers: const ['Pregão 014/2026'],
    pageCount: 48,
    chunkCount: 190,
    errorMessage: null,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Document(
    id: 'doc-sumula',
    filename: 'Sumula_Vinculante_13.pdf',
    status: DocumentStatus.processing,
    title: null,
    docType: null,
    rawDocType: null,
    identifiers: null,
    pageCount: null,
    chunkCount: null,
    errorMessage: null,
    createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
    updatedAt: DateTime.now().subtract(const Duration(seconds: 20)),
  ),
  Document(
    id: 'doc-falhou',
    filename: 'Peticao_Digitalizada.pdf',
    status: DocumentStatus.failed,
    title: null,
    docType: null,
    rawDocType: null,
    identifiers: null,
    pageCount: null,
    chunkCount: null,
    errorMessage: 'Não foi possível extrair texto: PDF sem camada textual',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
