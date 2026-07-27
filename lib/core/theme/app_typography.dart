import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Poppins, weights 300/400/500/600 — nunca abaixo de 300.
///
/// Os tamanhos em `rem` do design foram convertidos a 16px de base:
/// .62rem ≈ 10, .66rem ≈ 10.5, .68rem ≈ 11, .7rem ≈ 11, .72rem ≈ 11.5,
/// .78rem ≈ 12.5, .84rem ≈ 13.5, .86rem ≈ 14, .88rem ≈ 14, .92rem ≈ 15,
/// .95rem ≈ 15, 1.05rem ≈ 17, 1.3rem ≈ 21, 1.9rem ≈ 30.
abstract final class AppTypography {
  static TextStyle _poppins({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    Color? color,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Logo/splash do login — 30px/600.
  static TextStyle get display => _poppins(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  /// H1 de tela — 23px/600.
  static TextStyle get screenTitle => _poppins(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.blue900,
  );

  /// Título do sheet de login — 21px/600.
  static TextStyle get sectionTitle => _poppins(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.blue900,
  );

  /// Título no header das telas — 17px/600.
  static TextStyle get headerBar => _poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.blue900,
  );

  /// Nome de documento, nome de usuário — 16px/500.
  static TextStyle get cardTitle => _poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.blue900,
  );

  /// Mensagens de chat e parágrafos — 14px/300.
  static TextStyle get body => _poppins(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.6,
    color: AppColors.bodyText,
  );

  /// Itens de lista e botões — 14px/400–500.
  static TextStyle get label => _poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.blue900,
  );

  static TextStyle get labelMedium => _poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.blue900,
  );

  /// Legendas, subtítulo do header, metadados — 11–12px/300.
  static TextStyle get meta => _poppins(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    height: 1.5,
    color: AppColors.gray600,
  );

  /// Uppercase dourado com tracking largo — 11px/500.
  static TextStyle get kicker => _poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.gold500,
    letterSpacing: 2.0, // ≈ .18em
  );

  /// Labels da tab bar — 10px, 300 inativa / 500 ativa.
  static TextStyle get tabLabel => _poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1.2,
    color: AppColors.gray400,
  );

  static TextStyle get tabLabelActive => _poppins(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.blue900,
  );
}
