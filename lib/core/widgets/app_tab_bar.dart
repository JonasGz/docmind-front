import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icons.dart';

/// Tab bar de 3 itens. A aba ativa recebe a barra dourada 22×3 acima do ícone
/// e pinta ícone/label em blue-900 weight 500.
///
/// O `NavigationBar` do Material posiciona o indicador atrás do ícone, não
/// acima, e não tem como mover — por isso é próprio.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.maxContentWidth,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;

  /// Limita a largura dos três itens em janelas largas, mantendo o fundo e a
  /// borda superior atravessando a tela inteira.
  final double? maxContentWidth;

  static const _items = [
    (icon: AppIcons.chat, label: 'Chat'),
    (icon: AppIcons.document, label: 'Documentos'),
    (icon: AppIcons.settings, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.gray200)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sm,
        AppSpacing.screenPadding,
        AppSpacing.sm + bottomInset,
      ),
      child: Center(
        // heightFactor 1 mantém a barra do tamanho do conteúdo; sem isso ela
        // esticaria para a altura toda e o body ficaria com zero.
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxContentWidth ?? double.infinity,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _items.length; i++)
                _TabItem(
                  icon: _items[i].icon,
                  label: _items[i].label,
                  selected: i == currentIndex,
                  onTap: onTap == null ? null : () => onTap!(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.blue900 : AppColors.gray400;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 64,
            minHeight: AppSize.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 22,
                height: 3,
                decoration: BoxDecoration(
                  color: selected ? AppColors.gold500 : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Icon(icon, size: 21, color: color),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: selected
                    ? AppTypography.tabLabelActive
                    : AppTypography.tabLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
