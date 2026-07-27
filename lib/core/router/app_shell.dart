import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_tab_bar.dart';

/// Casca das três abas: mantém a tab bar fixa e troca só o conteúdo.
///
/// O `StatefulNavigationShell` preserva o estado de cada aba — a posição de
/// rolagem da lista de documentos e o rascunho do chat sobrevivem à troca.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O shell precisa ser filho direto do body: ele carrega uma GlobalKey e
      // qualquer widget intermediário faz o Flutter reparentá-lo a cada troca
      // de rota, disparando "Duplicate GlobalKey". A restrição de largura das
      // telas fica dentro de cada página.
      body: navigationShell,
      // A tab bar ocupa a largura toda (a borda superior precisa atravessar a
      // tela); só os três itens ficam contidos.
      bottomNavigationBar: AppTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goToBranch,
        maxContentWidth: 600,
      ),
    );
  }

  void _goToBranch(int index) {
    // `initialLocation: true` ao tocar na aba já ativa volta ao topo da pilha
    // daquela aba — comportamento esperado de tab bar.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
