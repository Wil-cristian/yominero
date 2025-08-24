import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData yoMineroTheme = _buildTheme();

ThemeData _buildTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    primary: AppColors.primary,
  ).copyWith(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryContainer,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondaryContainer,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.white,
    onSecondary: AppColors.onColor(AppColors.secondary),
    onSurface: AppColors.textPrimary,
    onError: AppColors.white,
  );

  return base.copyWith(
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    textTheme: base.textTheme.copyWith(
      bodyLarge:
          base.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
      bodyMedium:
          base.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline, width: .8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline, width: .8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.secondaryContainer,
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(color: AppColors.textPrimary),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: TextStyle(color: AppColors.white),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      margin: const EdgeInsets.all(8),
    ),
    dividerColor: AppColors.outline,
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}

// Removed unused PalettePage widget (was only for manual color preview).
