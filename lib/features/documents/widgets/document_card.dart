import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/relative_time.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_chip.dart';
import '../models/document.dart';
import '../models/document_status.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onDelete,
  });

  final Document document;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(document.id),
      direction: onDelete == null
          ? DismissDirection.none
          : DismissDirection.endToStart,
      background: const _DeleteBackground(),
      confirmDismiss: (_) async {
        onDelete?.call();

        return false;
      },
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            const _FileTypeBadge(),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    document.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(_metaLine, style: AppTypography.meta),
                  if (document.status.isPending) ...[
                    const SizedBox(height: 6),
                    const _IndeterminateProgress(),
                  ],
                  if (document.status.hasFailed &&
                      document.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      document.errorMessage!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.meta.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _StatusIndicator(document.status),
          ],
        ),
      ),
    );
  }

  String get _metaLine {
    final parts = <String>[
      if (document.pageCount case final pages?)
        pages == 1 ? '1 página' : '$pages páginas',
      if (document.docType?.label case final label? when document.title != null)
        label,
      relativeTime(document.createdAt),
    ];
    return parts.join(' · ');
  }
}

class _FileTypeBadge extends StatelessWidget {
  const _FileTypeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Text(
        'PDF',
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

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator(this.status);

  final DocumentStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      DocumentStatus.indexed => const AppChip.status(
        label: 'Pronto',
        color: AppColors.success,
      ),
      DocumentStatus.failed => const AppChip.status(
        label: 'Falhou',
        color: AppColors.danger,
      ),
      DocumentStatus.uploaded || DocumentStatus.processing => const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.gold500,
        ),
      ),
      DocumentStatus.unknown => const SizedBox.shrink(),
    };
  }
}

class _IndeterminateProgress extends StatelessWidget {
  const _IndeterminateProgress();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: const LinearProgressIndicator(
        minHeight: 4,
        backgroundColor: AppColors.gray200,
        color: AppColors.gold500,
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.danger),
    );
  }
}
