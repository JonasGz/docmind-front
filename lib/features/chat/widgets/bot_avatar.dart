import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_icons.dart';

/// Quadrado 30×30 blue-900 com o sparkle dourado, à esquerda das mensagens
/// do assistente.
class BotAvatar extends StatelessWidget {
  const BotAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.blue900,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Center(
        child: SparkleIcon(size: 15, color: AppColors.gold500),
      ),
    );
  }
}
