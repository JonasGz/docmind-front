import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.blue900,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.blue900,
          onPrimary: AppColors.white,
          secondary: AppColors.gold500,
          onSecondary: AppColors.blue900,
          surface: AppColors.white,
          onSurface: AppColors.blue900,
          error: AppColors.danger,
          outline: AppColors.gray200,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.screenBackground,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: AppColors.gray600,
        displayColor: AppColors.blue900,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.gray200,
        thickness: 1,
        space: 1,
      ),
      splashFactory: InkRipple.splashFactory,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.blue900.withValues(alpha: 0.45);
            }
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)) {
              return AppColors.blue700;
            }
            return AppColors.blue900;
          }),
          foregroundColor: const WidgetStatePropertyAll(AppColors.white),
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSize.minTouchTarget),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelMedium),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)) {
              return AppColors.gray100;
            }
            return AppColors.white;
          }),
          foregroundColor: const WidgetStatePropertyAll(AppColors.blue900),
          side: WidgetStateProperty.resolveWith((states) {
            final pressed =
                states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered);
            return BorderSide(
              color: pressed ? AppColors.gold500 : AppColors.gray200,
              width: 1.5,
            );
          }),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSize.minTouchTarget),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          textStyle: WidgetStatePropertyAll(AppTypography.labelMedium),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.screenBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.body.copyWith(color: AppColors.gray400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.gold500),
        ),
      ),

      focusColor: AppColors.gold500,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.blue900,
        selectionColor: AppColors.goldSelection,
        selectionHandleColor: AppColors.gold500,
      ),
    );
  }
}
