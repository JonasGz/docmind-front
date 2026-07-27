import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';

/// Histórico de conversas, empilhado sobre a aba Chat.
///
/// Fase 2: esqueleto navegável. A lista real, com os models e o mock,
/// entra na Fase 6 — o design não tem tela para ela, então é construída a
/// partir do `ConversationResponse` do backend.
class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'A lista de conversas chega na Fase 6.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(color: AppColors.gray400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
