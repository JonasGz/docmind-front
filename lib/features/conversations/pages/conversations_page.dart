import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/relative_time.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/content_width.dart';
import '../../chat/viewmodels/chat_viewmodel.dart';
import '../models/conversation.dart';
import '../viewmodels/conversations_viewmodel.dart';

class ConversationsPage extends ConsumerWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsViewModelProvider);

    return Scaffold(
      body: ContentWidth(
        child: Column(
          children: [
            AppHeader(
              title: 'Conversas',
              action: IconButton(
                icon: const Icon(Icons.close, color: AppColors.blue900),
                tooltip: 'Fechar',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: switch (conversations) {
                AsyncData(:final value) when value.isEmpty =>
                  const _EmptyState(),
                AsyncData(:final value) => _ConversationList(
                  conversations: value,
                  onOpen: (conversation) => _open(context, ref, conversation),
                  onDelete: (conversation) =>
                      _confirmDelete(context, ref, conversation),
                ),
                AsyncError() => _ErrorState(
                  onRetry: () => ref
                      .read(conversationsViewModelProvider.notifier)
                      .refresh(),
                ),
                _ => const Center(
                  child: CircularProgressIndicator(color: AppColors.gold500),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    Conversation conversation,
  ) async {
    await ref
        .read(chatViewModelProvider.notifier)
        .openConversation(conversation.id);

    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Conversation conversation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conversa?'),
        content: Text(
          '"${conversation.title}" e todas as suas mensagens serão perdidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref
        .read(conversationsViewModelProvider.notifier)
        .delete(conversation.id);
  }
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({
    required this.conversations,
    required this.onOpen,
    required this.onDelete,
  });

  final List<Conversation> conversations;
  final void Function(Conversation) onOpen;
  final void Function(Conversation) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: conversations.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return AppCard(
          onTap: () => onOpen(conversation),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      conversation.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.cardTitle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      relativeTime(conversation.updatedAt),
                      style: AppTypography.meta,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppColors.gray400,
                tooltip: 'Excluir conversa',
                onPressed: () => onDelete(conversation),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'Nenhuma conversa ainda.\nSuas perguntas aparecem aqui.',
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: AppColors.gray400),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Não foi possível carregar suas conversas.',
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar de novo'),
            ),
          ],
        ),
      ),
    );
  }
}
