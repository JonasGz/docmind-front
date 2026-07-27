import 'dart:typed_data';

import 'package:docmind/core/router/app_router.dart';
import 'package:docmind/core/router/routes.dart';
import 'package:docmind/features/documents/datasources/documents_datasource.dart';
import 'package:docmind/features/documents/models/document.dart';
import 'package:docmind/features/documents/models/document_status.dart';
import 'package:docmind/features/documents/providers/documents_providers.dart';
import 'package:docmind/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Datasource controlado — a seam única de teste, injetada por override.
class _FakeDatasource implements DocumentsDatasource {
  _FakeDatasource(this.documents);

  List<Document> documents;
  Object? listError;
  int listCalls = 0;

  @override
  Future<List<Document>> list() async {
    listCalls++;
    if (listError case final error?) throw error;
    return documents;
  }

  @override
  Future<Document> byId(String id) async =>
      documents.firstWhere((d) => d.id == id);

  @override
  Future<Document> upload({
    required String filename,
    required Uint8List bytes,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) async {
    documents = documents.where((d) => d.id != id).toList();
  }

  @override
  Future<String> downloadUrl(String id) async => 'fake://$id';
}

Document _doc({
  required String id,
  required String filename,
  DocumentStatus status = DocumentStatus.indexed,
  String? title,
  int? pageCount,
  List<String>? identifiers,
  String? errorMessage,
}) {
  final now = DateTime.now();
  return Document(
    id: id,
    filename: filename,
    status: status,
    title: title,
    docType: null,
    rawDocType: null,
    identifiers: identifiers,
    pageCount: pageCount,
    chunkCount: null,
    errorMessage: errorMessage,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<void> pumpDocuments(
    WidgetTester tester,
    _FakeDatasource datasource,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = createRouter(initialLocation: Routes.documents);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [documentsDatasourceProvider.overrideWithValue(datasource)],
        child: DocMindApp(router: router),
      ),
    );
    await settle(tester);
  }

  testWidgets('mostra os documentos e conta no cabeçalho', (tester) async {
    await pumpDocuments(
      tester,
      _FakeDatasource([
        _doc(
          id: '1',
          filename: 'Contrato_Locacao.pdf',
          title: 'Contrato de Locação',
          pageCount: 12,
        ),
        _doc(id: '2', filename: 'Parecer.pdf', pageCount: 48),
      ]),
    );

    expect(find.text('2 documentos'), findsOneWidget);
    // Prefere o título extraído ao nome do arquivo.
    expect(find.text('Contrato de Locação'), findsOneWidget);
    expect(find.text('Parecer.pdf'), findsOneWidget);
  });

  testWidgets('singular quando há um documento só', (tester) async {
    await pumpDocuments(
      tester,
      _FakeDatasource([_doc(id: '1', filename: 'Unico.pdf')]),
    );

    expect(find.text('1 documento'), findsOneWidget);
  });

  testWidgets('não exibe tamanho de arquivo nem percentual', (tester) async {
    // Ambos aparecem no desenho mas não existem no contrato do backend.
    await pumpDocuments(
      tester,
      _FakeDatasource([
        _doc(
          id: '1',
          filename: 'Processando.pdf',
          status: DocumentStatus.processing,
        ),
      ]),
    );

    expect(find.textContaining('MB'), findsNothing);
    expect(find.textContaining('%'), findsNothing);

    // Barra indeterminada: sem valor definido.
    final progress = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progress.value, isNull);
  });

  testWidgets('o badge é sempre PDF', (tester) async {
    // O backend recusa qualquer outro tipo com 415.
    await pumpDocuments(
      tester,
      _FakeDatasource([_doc(id: '1', filename: 'Documento.pdf')]),
    );

    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('DOCX'), findsNothing);
  });

  testWidgets('mostra o erro de um documento que falhou', (tester) async {
    await pumpDocuments(
      tester,
      _FakeDatasource([
        _doc(
          id: '1',
          filename: 'Digitalizada.pdf',
          status: DocumentStatus.failed,
          errorMessage: 'PDF sem camada textual',
        ),
      ]),
    );

    expect(find.text('Falhou'), findsOneWidget);
    expect(find.text('PDF sem camada textual'), findsOneWidget);
  });

  testWidgets('a busca filtra por nome, título e identificadores', (
    tester,
  ) async {
    await pumpDocuments(
      tester,
      _FakeDatasource([
        _doc(
          id: '1',
          filename: 'a.pdf',
          title: 'Contrato de Locação',
          identifiers: ['CNJ 0001234-56.2026.8.11.0001'],
        ),
        _doc(id: '2', filename: 'Parecer_Licitacao.pdf'),
      ]),
    );

    // Por título.
    await tester.enterText(find.byType(TextField), 'locação');
    await settle(tester);
    expect(find.text('Contrato de Locação'), findsOneWidget);
    expect(find.text('Parecer_Licitacao.pdf'), findsNothing);

    // Por nome de arquivo.
    await tester.enterText(find.byType(TextField), 'parecer');
    await settle(tester);
    expect(find.text('Parecer_Licitacao.pdf'), findsOneWidget);
    expect(find.text('Contrato de Locação'), findsNothing);

    // Por identificador — o número do processo é como advogado busca.
    await tester.enterText(find.byType(TextField), '0001234-56');
    await settle(tester);
    expect(find.text('Contrato de Locação'), findsOneWidget);

    // Limpar devolve os dois.
    await tester.enterText(find.byType(TextField), '');
    await settle(tester);
    expect(find.text('Contrato de Locação'), findsOneWidget);
    expect(find.text('Parecer_Licitacao.pdf'), findsOneWidget);
  });

  testWidgets('faz polling enquanto há documento processando', (tester) async {
    final datasource = _FakeDatasource([
      _doc(
        id: '1',
        filename: 'Processando.pdf',
        status: DocumentStatus.processing,
      ),
    ]);

    await pumpDocuments(tester, datasource);
    final afterLoad = datasource.listCalls;

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(
      datasource.listCalls,
      greaterThan(afterLoad),
      reason: 'com documento pendente o polling deve continuar consultando',
    );

    // O documento fica pronto: o polling precisa parar.
    datasource.documents = [_doc(id: '1', filename: 'Processando.pdf')];
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    final afterReady = datasource.listCalls;

    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
    expect(
      datasource.listCalls,
      afterReady,
      reason: 'sem documento pendente o polling deve cessar',
    );
  });

  testWidgets('não faz polling quando tudo já está indexado', (tester) async {
    final datasource = _FakeDatasource([_doc(id: '1', filename: 'Pronto.pdf')]);

    await pumpDocuments(tester, datasource);
    final afterLoad = datasource.listCalls;

    await tester.pump(const Duration(seconds: 6));
    await tester.pump();
    expect(datasource.listCalls, afterLoad);
  });

  testWidgets('erro de carregamento oferece nova tentativa', (tester) async {
    final datasource = _FakeDatasource([])..listError = StateError('sem rede');

    await pumpDocuments(tester, datasource);

    expect(
      find.text('Não foi possível carregar seus documentos.'),
      findsOneWidget,
    );

    datasource
      ..listError = null
      ..documents = [_doc(id: '1', filename: 'Recuperado.pdf')];

    await tester.tap(find.text('Tentar de novo'));
    await settle(tester);

    expect(find.text('Recuperado.pdf'), findsOneWidget);
  });
}
