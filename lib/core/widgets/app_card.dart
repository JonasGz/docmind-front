import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _highlighted = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHighlighted(true),
      onExit: (_) => _setHighlighted(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: widget.onTap == null ? null : (_) => _setHighlighted(true),
        onTapUp: widget.onTap == null ? null : (_) => _setHighlighted(false),
        onTapCancel: widget.onTap == null ? null : () => _setHighlighted(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _highlighted && widget.onTap != null
                  ? AppColors.gold500
                  : AppColors.gray200,
            ),
            boxShadow: AppShadows.card,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  void _setHighlighted(bool value) {
    if (widget.onTap == null || _highlighted == value) return;
    setState(() => _highlighted = value);
  }
}
