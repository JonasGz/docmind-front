import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_tab_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: AppTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goToBranch,
        maxContentWidth: 600,
      ),
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
