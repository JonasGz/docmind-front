import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

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

  static TextStyle get display => _poppins(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static TextStyle get screenTitle => _poppins(
    fontSize: 23,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.blue900,
  );

  static TextStyle get sectionTitle => _poppins(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.blue900,
  );

  static TextStyle get headerBar => _poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.blue900,
  );

  static TextStyle get cardTitle => _poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.blue900,
  );

  static TextStyle get body => _poppins(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.6,
    color: AppColors.bodyText,
  );

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

  static TextStyle get meta => _poppins(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    height: 1.5,
    color: AppColors.gray600,
  );

  static TextStyle get kicker => _poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.gold500,
    letterSpacing: 2.0,
  );

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
