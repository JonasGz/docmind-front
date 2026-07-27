import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icon_button.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/content_width.dart';
import '../../documents/viewmodels/documents_viewmodel.dart';
import '../../settings/providers/preferences_provider.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_empty_state.dart';
import '../widgets/typing_indicator.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _composerController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatViewModelProvider);
    final indexedCount = ref.watch(indexedDocumentCountProvider);
    final citeSources = ref.watch(citeSourcesPreferenceProvider).value ?? true;

    ref.listen(chatViewModelProvider, (previous, next) {
      if (next.messages.length != previous?.messages.length ||
          next.isAwaitingAnswer != previous?.isAwaitingAnswer) {
        _scrollToBottom();
      }
      if (next.sendError != null && previous?.sendError == null) {
        _showSendError();
      }
    });

    return ContentWidth(
      child: Column(
        children: [
          AppHeader(
            title: 'Chat',
            subtitle: _contextLabel(indexedCount),
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton.outline(
                  icon: Icons.history,
                  semanticLabel: 'Conversas',
                  size: 38,
                  onPressed: () => context.push(Routes.conversations),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppIconButton.primary(
                  icon: AppIcons.add,
                  semanticLabel: 'Nova conversa',
                  size: 38,
                  onPressed: chat.isEmpty
                      ? null
                      : () {
                          ref
                              .read(chatViewModelProvider.notifier)
                              .startNewConversation();
                          _composerController.clear();
                        },
                ),
              ],
            ),
          ),
          Expanded(
            child: chat.isEmpty && !chat.isAwaitingAnswer
                ? ChatEmptyState(indexedCount: indexedCount)
                : _MessageList(
                    controller: _scrollController,
                    chat: chat,
                    showSources: citeSources,
                  ),
          ),
          ChatComposer(
            controller: _composerController,
            enabled: !chat.isAwaitingAnswer,
            onSend: _send,
          ),
        ],
      ),
    );
  }

  /// O subtítulo consome o mesmo provider global da aba Documentos, sem
  /// buscar nada por conta própria.
  String _contextLabel(int count) => switch (count) {
    0 => 'nenhum documento no contexto',
    1 => '1 documento no contexto',
    _ => '$count documentos no contexto',
  };

  void _send() {
    final text = _composerController.text;
    if (text.trim().isEmpty) return;

    _composerController.clear();
    ref.read(chatViewModelProvider.notifier).send(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSendError() {
    final failed = ref.read(chatViewModelProvider).sendError;
    if (failed == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Não foi possível enviar a pergunta.'),
        backgroundColor: AppColors.danger,
        action: SnackBarAction(
          label: 'Tentar de novo',
          textColor: AppColors.white,
          onPressed: () {
            ref.read(chatViewModelProvider.notifier).clearError();
            _send();
          },
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.controller,
    required this.chat,
    required this.showSources,
  });

  final ScrollController controller;
  final ChatState chat;
  final bool showSources;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: chat.messages.length + (chat.isAwaitingAnswer ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) {
        if (index == chat.messages.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: TypingIndicator(),
          );
        }

        final message = chat.messages[index];
        if (message.role.isUser) {
          return UserBubble(text: message.content);
        }

        return BotBubble(
          text: message.content,
          sources: showSources ? (message.sources ?? const []) : const [],
        );
      },
    );
  }
}

/// Texto de apoio quando não há mensagens — a saudação do desenho não é
/// persistida pela API, então vive só na interface.
class ChatEmptyStateText extends StatelessWidget {
  const ChatEmptyStateText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Pergunte algo sobre seus documentos.',
      style: AppTypography.body.copyWith(color: AppColors.gray400),
    );
  }
}
