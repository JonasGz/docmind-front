import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';

/// Visualizador de PDF, empilhado sobre a aba de origem.
///
/// Fase 2: esqueleto navegável, para provar que a rota carrega o `id` e a
/// página. O `pdfrx` e a renderização real entram na Fase 7.
class DocumentViewerPage extends StatelessWidget {
  const DocumentViewerPage({
    super.key,
    required this.documentId,
    this.initialPage,
  });

  final String documentId;

  /// Página inicial, quando o usuário chegou por um chip de fonte do chat.
  final int? initialPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Documento',
            subtitle: initialPage == null
                ? null
                : 'abrindo na página $initialPage',
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
                  'Visualizador de PDF na Fase 7.\nDocumento $documentId.',
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
