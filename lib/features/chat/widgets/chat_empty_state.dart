import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'bot_avatar.dart';

/// Saudação inicial do assistente.
///
/// É texto de interface, não uma mensagem persistida: o backend não guarda
/// saudação, e enviá-la sujaria o histórico da conversa.
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.indexedCount});

  /// Quantos documentos estão indexados — muda o que faz sentido sugerir.
  final int indexedCount;

  @override
  Widget build(BuildContext context) {
    final hasDocuments = indexedCount > 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BotAvatar(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasDocuments
                  ? 'Seus documentos já foram processados.'
                  : 'Nenhum documento processado ainda.',
              textAlign: TextAlign.center,
              style: AppTypography.cardTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasDocuments
                  ? 'Pergunte qualquer coisa sobre eles — cada resposta vem '
                        'com a fonte e a página de onde saiu.'
                  : 'Envie um PDF na aba Documentos para começar a perguntar.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.gray600),
            ),
          ],
        ),
      ),
    );
  }
}
