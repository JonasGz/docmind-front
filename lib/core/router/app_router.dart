import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dev/gallery_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/conversations/pages/conversations_page.dart';
import '../../features/documents/pages/document_viewer_page.dart';
import '../../features/documents/pages/documents_page.dart';
import '../../features/settings/pages/settings_page.dart';
import 'app_shell.dart';
import 'routes.dart';

/// Rotas do aplicativo.
///
/// Fase 2: a estrutura completa de navegação, ainda sem guarda de sessão — o
/// redirecionamento por autenticação entra na Fase 9, quando existir token.
/// Enquanto isso o login é alcançável pela galeria e pelo "Sair da conta".
///
/// É uma função, não uma constante global: cada teste precisa de uma instância
/// própria, senão a rota atual vaza de um teste para o outro.
GoRouter createRouter({String initialLocation = Routes.chat}) {
  // As rotas empilhadas (histórico, visualizador) declaram este navigator
  // para cobrir a tab bar em vez de renderizar dentro da aba.
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.gallery,
        builder: (context, state) => const GalleryPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.chat,
                builder: (context, state) => const ChatPage(),
                routes: [
                  // Histórico empilhado sobre a aba Chat, não uma quarta aba.
                  // Vai no navigator raiz para cobrir a tab bar.
                  GoRoute(
                    path: 'conversations',
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => const ConversationsPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.documents,
                builder: (context, state) => const DocumentsPage(),
                routes: [
                  GoRoute(
                    path: Routes.documentViewer,
                    parentNavigatorKey: rootKey,
                    builder: (context, state) => DocumentViewerPage(
                      documentId: state.pathParameters['id']!,
                      initialPage: int.tryParse(
                        state.uri.queryParameters['page'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Instância única usada pelo aplicativo em produção.
final appRouter = createRouter();
