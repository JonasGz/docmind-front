import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../dev/gallery_page.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/conversations/pages/conversations_page.dart';
import '../../features/documents/pages/document_viewer_page.dart';
import '../../features/documents/pages/documents_page.dart';
import '../../features/settings/pages/settings_page.dart';
import 'app_shell.dart';
import 'routes.dart';

part 'app_router.g.dart';

GoRouter createRouter({String initialLocation = Routes.chat, Ref? ref}) {
  final rootKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: initialLocation,
    redirect: ref == null ? null : (context, state) => _guard(ref, state),
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

String? _guard(Ref ref, GoRouterState state) {
  final session = ref.read(authViewModelProvider);
  if (session.isLoading) return null;

  final isSignedIn = session.value != null;
  final atLogin = state.matchedLocation == Routes.login;

  if (!isSignedIn && !atLogin) return Routes.login;
  if (isSignedIn && atLogin) return Routes.chat;
  return null;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  ref.listen(authViewModelProvider, (_, _) {});
  return createRouter(ref: ref);
}
