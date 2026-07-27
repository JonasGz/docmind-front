import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppIconButton extends StatefulWidget {
  const AppIconButton.primary({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = AppSize.iconButton,
  }) : _variant = _IconButtonVariant.primary;

  const AppIconButton.gold({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = AppSize.iconButton,
  }) : _variant = _IconButtonVariant.gold;

  const AppIconButton.outline({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = AppSize.iconButton,
  }) : _variant = _IconButtonVariant.outline;

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final _IconButtonVariant _variant;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    final (background, foreground, border) = switch (widget._variant) {
      _IconButtonVariant.primary => (
        _pressed ? AppColors.gold500 : AppColors.blue900,
        AppColors.white,
        null,
      ),
      _IconButtonVariant.gold => (
        _pressed ? AppColors.gold300 : AppColors.gold500,
        AppColors.blue900,
        null,
      ),
      _IconButtonVariant.outline => (
        AppColors.white,
        AppColors.blue900,
        BorderSide(
          color: _pressed ? AppColors.gold500 : AppColors.gray200,
          width: 1.5,
        ),
      ),
    };

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        onEnter: (_) => _setPressed(true),
        onExit: (_) => _setPressed(false),
        child: GestureDetector(
          onTap: widget.onPressed,
          onTapDown: enabled ? (_) => _setPressed(true) : null,
          onTapUp: enabled ? (_) => _setPressed(false) : null,
          onTapCancel: enabled ? () => _setPressed(false) : null,
          child: Opacity(
            opacity: enabled ? 1 : 0.45,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                border: border == null ? null : Border.fromBorderSide(border),
              ),
              child: Icon(
                widget.icon,
                size: widget.size * 0.42,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setPressed(bool value) {
    if (widget.onPressed == null || _pressed == value) return;
    setState(() => _pressed = value);
  }
}

enum _IconButtonVariant { primary, gold, outline }
