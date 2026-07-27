import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Toggle 46×27 com knob de 23px, conforme o design system.
///
/// O `Switch` do Material tem proporções e animação próprias que não batem
/// com o desenho, por isso este é próprio.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  static const _width = 46.0;
  static const _height = 27.0;
  static const _knob = 23.0;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        // Mantém o alvo de toque em 44px sem esticar o desenho.
        child: SizedBox(
          height: 44,
          width: _width,
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : 0.45,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: _width,
                height: _height,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: value ? AppColors.blue900 : AppColors.toggleOff,
                  borderRadius: BorderRadius.circular(_height / 2),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: _knob,
                    height: _knob,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.toggleKnob,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
