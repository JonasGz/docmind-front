import 'package:docmind/core/router/app_router.dart';
import 'package:docmind/core/router/routes.dart';
import 'package:docmind/core/widgets/app_tab_bar.dart';
import 'package:docmind/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const viewports = [
    ('iPhone 390×844', Size(390, 844)),
    ('janela larga 1200×900', Size(1200, 900)),
    ('janela baixa 800×600', Size(800, 600)),
  ];

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<GoRouter> pumpApp(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = createRouter();
    await tester.pumpWidget(ProviderScope(child: DocMindApp(router: router)));
    await settle(tester);
    return router;
  }

  for (final (name, size) in viewports) {
    testWidgets('as telas montam sem overflow — $name', (tester) async {
      final router = await pumpApp(tester, size);

      for (final route in [
        Routes.chat,
        Routes.documents,
        '${Routes.documents}/viewer/doc-1?page=4',
        Routes.settings,
        Routes.conversations,
        Routes.login,
        Routes.gallery,
      ]) {
        router.go(route);
        await settle(tester);

        expect(
          tester.takeException(),
          isNull,
          reason: 'a rota $route estourou em $name',
        );
      }
    });
  }

  Finder tab(String label) =>
      find.descendant(of: find.byType(AppTabBar), matching: find.text(label));

  testWidgets('a tab bar troca de aba e preserva o estado de cada uma', (
    tester,
  ) async {
    await pumpApp(tester, const Size(390, 844));

    expect(find.textContaining('no contexto'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'pergunta em rascunho');
    await settle(tester);

    await tester.tap(tab('Documentos'));
    await settle(tester);

    expect(find.textContaining('documento'), findsWidgets);

    await tester.tap(tab('Ajustes'));
    await settle(tester);
    expect(find.text('Ajustes'), findsWidgets);

    await tester.tap(tab('Chat'));
    await settle(tester);
    expect(
      find.text('pergunta em rascunho'),
      findsOneWidget,
      reason: 'o StatefulShellRoute deve preservar o estado da aba',
    );
  });

  testWidgets('o histórico de conversas empilha sobre a aba Chat', (
    tester,
  ) async {
    await pumpApp(tester, const Size(390, 844));

    await tester.tap(find.byIcon(Icons.history));
    await settle(tester);
    expect(find.text('Conversas'), findsWidgets);

    expect(tab('Chat'), findsNothing);

    await tester.tap(find.byIcon(Icons.close));
    await settle(tester);
    expect(find.textContaining('no contexto'), findsOneWidget);
  });
}
