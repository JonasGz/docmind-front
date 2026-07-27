import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_chip.dart';

enum DocumentCardStatus { ready, processing, failed }

/// Card de documento: badge do tipo, nome, metadados e — conforme o status —
/// barra de progresso + spinner, ou o chip "Pronto".
class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.fileType,
    required this.name,
    required this.meta,
    required this.status,
    this.progress,
    this.onTap,
  });

  final String fileType;
  final String name;
  final String meta;
  final DocumentCardStatus status;

  /// 0–1 quando determinado; `null` renderiza barra indeterminada.
  /// O backend não expõe percentual — a Fase 4 sempre passa `null`
  /// (decisão Q3).
  final double? progress;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          _FileTypeBadge(fileType),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(meta, style: AppTypography.meta),
                if (status == DocumentCardStatus.processing) ...[
                  const SizedBox(height: 6),
                  _ProgressBar(progress),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          switch (status) {
            DocumentCardStatus.ready => const AppChip.status(
              label: 'Pronto',
              color: AppColors.success,
            ),
            DocumentCardStatus.failed => const AppChip.status(
              label: 'Falhou',
              color: AppColors.danger,
            ),
            DocumentCardStatus.processing => const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.gold500,
              ),
            ),
          },
        ],
      ),
    );
  }
}

/// Retângulo 38×44 com a sigla do tipo. PDF é `danger`; qualquer outro tipo
/// cai em blue-900 — no design o DOCX aparece assim.
class _FileTypeBadge extends StatelessWidget {
  const _FileTypeBadge(this.fileType);

  final String fileType;

  @override
  Widget build(BuildContext context) {
    final background = fileType.toUpperCase() == 'PDF'
        ? AppColors.danger
        : AppColors.blue900;

    return Container(
      width: 38,
      height: 44,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Text(
        fileType.toUpperCase(),
        style: AppTypography.tabLabelActive.copyWith(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar(this.progress);

  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.gray200,
              color: AppColors.gold500,
            ),
          ),
        ),
        if (progress case final progress?) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${(progress * 100).round()}%',
            style: AppTypography.tabLabelActive.copyWith(
              fontSize: 10,
              color: AppColors.gold500,
            ),
          ),
        ],
      ],
    );
  }
}
