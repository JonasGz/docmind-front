import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppChip extends StatelessWidget {
  const AppChip.accent({super.key, required this.label, this.icon, this.onTap})
    : _variant = _ChipVariant.accent,
      _dotColor = null;

  const AppChip.neutral({super.key, required this.label, this.icon, this.onTap})
    : _variant = _ChipVariant.neutral,
      _dotColor = null;

  const AppChip.status({
    super.key,
    required this.label,
    required Color color,
    this.onTap,
  }) : _variant = _ChipVariant.status,
       _dotColor = color,
       icon = null;

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final _ChipVariant _variant;
  final Color? _dotColor;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, border) = switch (_variant) {
      _ChipVariant.accent => (AppColors.goldTint, AppColors.blue900, null),
      _ChipVariant.neutral => (
        Colors.transparent,
        AppColors.gray600,
        const BorderSide(color: AppColors.gray200),
      ),
      _ChipVariant.status => (
        _dotColor!.withValues(alpha: 0.1),
        _dotColor,
        null,
      ),
    };

    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: border == null ? null : Border.fromBorderSide(border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_variant == _ChipVariant.status)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: _dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          else if (icon case final icon?)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: Icon(icon, size: 11, color: foreground),
            ),

          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.tabLabelActive.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: content,
    );
  }
}

enum _ChipVariant { accent, neutral, status }
