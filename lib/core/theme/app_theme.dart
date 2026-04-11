import 'package:cineticket/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.textPrimary,
      onPrimary: AppColors.voidBlack,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.accent,
      onError: Colors.white,
      outline: AppColors.outline,
    );

    final borderRadius = BorderRadius.circular(14);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textSecondary,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceElevated.withOpacity(0.72),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.outline.withOpacity(0.35)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.outline.withOpacity(0.5),
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.85)),
        floatingLabelStyle: const TextStyle(color: AppColors.spotlightSoft),
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: AppColors.outline.withOpacity(0.65)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: AppColors.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: AppColors.accent.withOpacity(0.8)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.outline,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: 0,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        circularTrackColor: AppColors.outline,
      ),
    );
  }
}
