import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/content_width.dart';
import '../widgets/document_card.dart';
import '../widgets/upload_button.dart';

/// Tela de documentos.
///
/// Fase 1: maquete estática com os textos literais do design — inclusive
/// `2,1 MB`, `64%` e o badge `DOCX`, que **não existem** no contrato do
/// backend. A Fase 4 reescreve esta tela contra o `DocumentResponse` real.
class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentWidth(
      child: Column(
        children: [
          AppHeader(
            title: 'Documentos',
            subtitle: '4 arquivos · 28,4 MB',
            bottom: _SearchField(),
          ),
          Expanded(child: _DocumentList()),
        ],
      ),
    );
  }
}

/// Campo de busca pill. Na Fase 1 é só a aparência; a busca client-side
/// (decisão Q15) entra na Fase 4.
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.minTouchTarget,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.screenBackground,
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.search, size: 15, color: AppColors.gray400),
          const SizedBox(width: AppSpacing.md),
          Text(
            'Buscar documento',
            style: AppTypography.body.copyWith(
              fontSize: 13.5,
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentList extends StatelessWidget {
  const _DocumentList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        UploadButton(onPressed: () {}),
        const SizedBox(height: AppSpacing.md),
        DocumentCard(
          fileType: 'PDF',
          name: 'Contrato_Locacao.pdf',
          meta: '12 páginas · 2,1 MB · há 2 dias',
          status: DocumentCardStatus.ready,
          onTap: () => context.push('${Routes.documents}/viewer/doc-1'),
        ),
        const SizedBox(height: AppSpacing.md),
        DocumentCard(
          fileType: 'PDF',
          name: 'Relatorio_Financeiro_Q2.pdf',
          meta: '48 páginas · 8,7 MB · há 5 dias',
          status: DocumentCardStatus.ready,
          onTap: () => context.push('${Routes.documents}/viewer/doc-2'),
        ),
        const SizedBox(height: AppSpacing.md),
        const DocumentCard(
          fileType: 'DOCX',
          name: 'Ata_Reuniao_Junho.docx',
          meta: '6 páginas · 340 KB · agora',
          status: DocumentCardStatus.processing,
          progress: 0.64,
        ),
        const SizedBox(height: AppSpacing.md),
        const DocumentCard(
          fileType: 'PDF',
          name: 'Manual_Produto_v3.pdf',
          meta: '112 páginas · 17,2 MB · há 1 semana',
          status: DocumentCardStatus.ready,
        ),
      ],
    );
  }
}
