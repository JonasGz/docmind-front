import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: DocMindApp()));
}

class DocMindApp extends ConsumerWidget {
  const DocMindApp({super.key, this.router});

  /// Injetável para que cada teste use um router próprio, sem a guarda de
  /// sessão.
  final GoRouter? router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Doc Mind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router ?? ref.watch(appRouterProvider),
    );
  }
}
