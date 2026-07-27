import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.initials,
    required this.name,
    required this.email,
    this.badge,
    this.onTap,
  });

  final String initials;
  final String name;
  final String email;

  final String? badge;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.blue900,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.gold500.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold500, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: AppTypography.cardTitle.copyWith(
                  fontSize: 17,
                  color: AppColors.gold300,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTypography.cardTitle.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: AppTypography.meta.copyWith(
                      fontSize: 11.5,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  if (badge case final badge?) ...[
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold500,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(badge, style: AppTypography.tabLabelActive),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 17,
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
