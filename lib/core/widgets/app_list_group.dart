import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppListGroup extends StatelessWidget {
  const AppListGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title case final title?) ...[
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: AppSpacing.sm),
            child: Text(title.toUpperCase(), style: AppTypography.kicker),
          ),
        ],
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.gray200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    const Divider(height: 1, thickness: 1),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppListRow extends StatelessWidget {
  const AppListRow({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.value,
    this.showChevron = false,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;

  final Widget? trailing;

  final String? value;

  final bool showChevron;
  final VoidCallback? onTap;

  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final foreground = destructive ? AppColors.danger : AppColors.blue900;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSize.minTouchTarget),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: foreground),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.label.copyWith(color: foreground),
              ),
            ),
            if (value case final value?) ...[
              Text(value, style: AppTypography.body.copyWith(fontSize: 12.5)),
              const SizedBox(width: AppSpacing.md),
            ],
            ?trailing,
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.gray400,
              ),
          ],
        ),
      ),
    );
  }
}
