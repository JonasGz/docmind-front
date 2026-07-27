import 'package:flutter/material.dart';

/// Paleta do design system (ref/FRONT/design-system.md).
abstract final class AppColors {
  static const blue900 = Color(0xFF0D2842);
  static const blue700 = Color(0xFF17406E);
  static const gold500 = Color(0xFFCF9B36);
  static const gold300 = Color(0xFFE5B655);
  static const gray100 = Color(0xFFF4F5F7);
  static const gray200 = Color(0xFFE4E8EF);
  static const gray600 = Color(0xFF5A6473);
  static const gray400 = Color(0xFF9AA3B0);
  static const white = Color(0xFFFFFFFF);

  static const success = Color(0xFF1E7D4F);
  static const danger = Color(0xFFC0392B);

  /// Fundo das telas internas — no design é #f4f6f9, ligeiramente distinto de
  /// gray-100 (#F4F5F7), que é reservado a fundos de input.
  static const screenBackground = Color(0xFFF4F6F9);

  /// Corpo das bolhas do bot: #3b4452, entre blue-900 e gray-600.
  static const bodyText = Color(0xFF3B4452);

  /// Fundo do toggle desligado.
  static const toggleOff = Color(0xFFD4D9E1);

  /// Tints de acento.
  static const goldTint = Color(0x24CF9B36); // rgba(207,155,54,.14)
  static const goldTintSoft = Color(0x0FCF9B36); // rgba(207,155,54,.06)
  static const goldSelection = Color(0x40CF9B36); // rgba(207,155,54,.25)
  static const successTint = Color(0x1A1E7D4F); // rgba(30,125,79,.1)
}
