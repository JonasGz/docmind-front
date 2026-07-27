import 'package:docmind/core/router/app_router.dart';
import 'package:docmind/core/router/routes.dart';
import 'package:docmind/features/conversations/providers/conversations_providers.dart';
import 'package:docmind/features/documents/providers/documents_providers.dart';
import 'package:docmind/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';

void main() {
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<FakeConversationsDatasource> pumpChat(
    WidgetTester tester, {
    FakeConversationsDatasource? conversations,
    List<String> indexedDocuments = const ['doc-1'],
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final datasource = conversations ?? FakeConversationsDatasource();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          conversationsDatasourceProvider.overrideWithValue(datasource),
          documentsDatasourceProvider.overrideWithValue(
            FakeDocumentsDatasource(
              indexedDocuments.map((id) => indexedDoc(id)).toList(),
            ),
          ),
        ],
        child: DocMindApp(router: createRouter(initialLocation: Routes.chat)),
      ),
    );
    await settle(tester);
    return datasource;
  }

  testWidgets('mostra a saudação e a contagem de documentos', (tester) async {
    await pumpChat(tester, indexedDocuments: const ['a', 'b']);

    expect(find.text('2 documentos no contexto'), findsOneWidget);
    expect(find.text('Seus documentos já foram processados.'), findsOneWidget);
  });

  testWidgets('sem documentos, convida a enviar um', (tester) async {
    await pumpChat(tester, indexedDocuments: const []);

    expect(find.text('nenhum documento no contexto'), findsOneWidget);
    expect(
      find.textContaining('Envie um PDF na aba Documentos'),
      findsOneWidget,
    );
  });

  testWidgets('envia a pergunta e mostra a resposta com o chip da fonte', (
    tester,
  ) async {
    await pumpChat(tester);

    await tester.enterText(find.byType(TextField), 'Qual o prazo?');
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Enviar'));
    await settle(tester);

    expect(find.text('Qual o prazo?'), findsOneWidget);
    expect(find.text('Resposta com fonte.'), findsOneWidget);
    expect(find.text('Contrato.pdf · pág. 4'), findsOneWidget);
  });

  testWidgets('a conversa só é criada no primeiro envio', (tester) async {
    // Sem isso o histórico encheria de conversas vazias a cada abertura.
    final datasource = await pumpChat(tester);
    expect(datasource.createCalls, 0);

    await tester.enterText(find.byType(TextField), 'primeira');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Enviar'));
    await settle(tester);
    expect(datasource.createCalls, 1);

    // A segunda mensagem reaproveita a conversa.
    await tester.enterText(find.byType(TextField), 'segunda');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Enviar'));
    await settle(tester);
    expect(datasource.createCalls, 1);
  });

  testWidgets('o botão de enviar fica inativo com o campo vazio', (
    tester,
  ) async {
    await pumpChat(tester);

    Future<void> tapSend() async {
      await tester.tap(find.bySemanticsLabel('Enviar'), warnIfMissed: false);
      await settle(tester);
    }

    await tapSend();
    expect(find.text('Seus documentos já foram processados.'), findsOneWidget);

    // Só espaços também não envia.
    await tester.enterText(find.byType(TextField), '   ');
    await tester.pump();
    await tapSend();
    expect(find.text('Seus documentos já foram processados.'), findsOneWidget);
  });

  testWidgets('mostra o indicador enquanto espera a resposta', (tester) async {
    final datasource = FakeConversationsDatasource(
      answerDelay: const Duration(seconds: 3),
    );
    await pumpChat(tester, conversations: datasource);

    await tester.enterText(find.byType(TextField), 'Qual o prazo?');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Enviar'));
    await tester.pump(const Duration(milliseconds: 300));

    // A pergunta aparece antes da resposta chegar.
    expect(find.text('Qual o prazo?'), findsOneWidget);
    expect(find.text('Aguardando a resposta…'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await settle(tester);
    expect(find.text('Resposta com fonte.'), findsOneWidget);
  });

  testWidgets('toque longo no chip abre o trecho e a similaridade', (
    tester,
  ) async {
    await pumpChat(tester);

    await tester.enterText(find.byType(TextField), 'Qual o prazo?');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Enviar'));
    await settle(tester);

    await tester.longPress(find.text('Contrato.pdf · pág. 4'));
    await settle(tester);

    expect(find.text('FONTE CITADA'), findsOneWidget);
    expect(
      find.textContaining('vigência do presente contrato'),
      findsOneWidget,
    );
    // O score fica visível: em matéria jurídica, calibra a confiança.
    expect(find.textContaining('87%'), findsOneWidget);
  });

  testWidgets('falha no envio devolve o erro sem perder a conversa', (
    tester,
  ) async {
    final datasource = FakeConversationsDatasource()
      ..sendError = StateError('sem rede');
    await pumpChat(tester, conversations: datasource);

    await tester.enterText(find.byType(TextField), 'Qual o prazo?');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Enviar'));
    await settle(tester);

    expect(find.text('Não foi possível enviar a pergunta.'), findsOneWidget);
    // A pergunta otimista sai da lista, para não parecer enviada.
    expect(find.text('Qual o prazo?'), findsNothing);
  });

  testWidgets('resposta sem base documental não exibe chip', (tester) async {
    final datasource = FakeConversationsDatasource(withSources: false);
    await pumpChat(tester, conversations: datasource);

    await tester.enterText(find.byType(TextField), 'receita de bolo');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Enviar'));
    await settle(tester);

    expect(find.textContaining('Não encontrei'), findsOneWidget);
    expect(find.textContaining('pág.'), findsNothing);
  });
}
