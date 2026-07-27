import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Header branco com a barra dourada de 4×22 à esquerda, título, subtítulo
/// opcional e ação à direita. Presente nas três telas internas.
///
/// O design especifica `padding-top: 62px` contando a status bar do iPhone;
/// aqui usamos o inset real do dispositivo + 12, para não desalinhar em
/// aparelhos sem notch.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  /// Conteúdo extra abaixo da linha do título (ex.: campo de busca).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray200)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        topInset + AppSpacing.md,
        AppSpacing.screenPadding,
        bottom == null ? AppSpacing.md : AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.gold500,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppTypography.headerBar),
                    // ignore: use_null_aware_elements
                    if (subtitle case final subtitle?)
                      Text(subtitle, style: AppTypography.meta),
                  ],
                ),
              ),
              ?action,
            ],
          ),
          if (bottom case final bottom?) ...[
            const SizedBox(height: AppSpacing.lg),
            bottom,
          ],
        ],
      ),
    );
  }
}
