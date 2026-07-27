import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_icons.dart';
import '../models/source.dart';
import 'bot_avatar.dart';
import 'source_detail_sheet.dart';

const _bubbleRadius = BorderRadius.only(
  topLeft: Radius.circular(2),
  topRight: Radius.circular(AppRadius.md),
  bottomLeft: Radius.circular(AppRadius.md),
  bottomRight: Radius.circular(AppRadius.md),
);

class BotBubble extends StatelessWidget {
  const BotBubble({super.key, required this.text, this.sources = const []});

  final String text;
  final List<Source> sources;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.88,
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.only(top: 2), child: BotAvatar()),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.gray200),
                      borderRadius: _bubbleRadius,
                      boxShadow: AppShadows.card,
                    ),
                    child: ClipRRect(
                      borderRadius: _bubbleRadius,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 3, color: AppColors.gold500),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.md,
                                ),
                                child: SelectableText(
                                  text,
                                  style: AppTypography.body,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (sources.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final source in sources)
                          _SourceChip(source: source),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.source});

  final Source source;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showSourceDetail(context, source),
      child: AppChip.accent(
        label: source.label,
        icon: AppIcons.document,
        onTap: () => context.push(
          '${Routes.documents}/viewer/${source.documentId}'
          '?page=${source.page}',
        ),
      ),
    );
  }
}

class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.blue900,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.md),
              topRight: Radius.circular(2),
              bottomLeft: Radius.circular(AppRadius.md),
              bottomRight: Radius.circular(AppRadius.md),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: SelectableText(
            text,
            style: AppTypography.body.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
