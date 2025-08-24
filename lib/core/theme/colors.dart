import 'package:flutter/material.dart';

/// Legacy color constants (kept for backward compatibility).
class YoMineroColors {
  YoMineroColors._();
  static const Color machineryOrange = Color(0xFFFF6F00);
  static const Color goldYellow = Color(0xFFFFD600);
  static const Color earthDark = Color(0xFF4E342E);
  static const Color sandLight = Color(0xFFF5F5DC);
  static const Color charcoal = Color(0xFF1C1C1C);
  static const Color stoneGray = Color(0xFF9E9E9E);
  static const Color alertRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color infoBlue = Color(0xFF1976D2);
  static const Color copper = Color(0xFFB87333);
  static const Color silver = Color(0xFFB0BEC5);
  static const Color graphite = Color(0xFF37474F);
}

/// New semantic palette following the color selection guide.
/// Names focus on role instead of specific hue to simplify future adjustments.
class AppColors {
  AppColors._();

  // Brand / primary system
  static const Color primary =
      Color(0xFFE06800); // slightly desaturated from old orange
  static const Color primaryContainer = Color(0xFFFFE5D1);
  static const Color primaryHover = Color(0xFFCB5E00);
  static const Color primaryPressed = Color(0xFFB35200);

  // Secondary / accent (amber-copper blend)
  static const Color secondary = Color(0xFFC87900);
  static const Color secondaryContainer = Color(0xFFFFF0DA);

  // Neutrals / backgrounds
  static const Color background = Color(0xFFF8F5EF);
  static const Color backgroundAlt = Color(0xFFF2EEE7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFFAF7F2);
  static const Color outline = Color(0xFFD5CBBF);

  // Text
  static const Color textPrimary = Color(0xFF282523);
  static const Color textSecondary = Color(0xFF5E574F);
  static const Color textDisabled = Color(0xFF9E948B);

  // States
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE4F3E5);
  static const Color error = Color(0xFFC62828);
  static const Color errorContainer = Color(0xFFFCE4E4);
  static const Color warning = Color(0xFFFFB300);
  static const Color warningContainer = Color(0xFFFFF6DA);
  static const Color info = Color(0xFF0F67B5);
  static const Color infoContainer = Color(0xFFE0F0FA);

  // Utility / decorative
  static const Color focus = Color(0xFF684200);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  /// Returns best contrasting on-color (black/white) for given [background].
  static Color onColor(Color background) =>
      background.computeLuminance() > 0.54 ? black : white;
}

extension AppColorScheme on BuildContext {
  Color get cPrimary => AppColors.primary;
  Color get cPrimaryContainer => AppColors.primaryContainer;
  Color get cSecondary => AppColors.secondary;
  Color get cSecondaryContainer => AppColors.secondaryContainer;
  Color get cBg => AppColors.background;
  Color get cBgAlt => AppColors.backgroundAlt;
  Color get cSurface => AppColors.surface;
  Color get cSurfaceAlt => AppColors.surfaceAlt;
  Color get cOutline => AppColors.outline;
  Color get cText => AppColors.textPrimary;
  Color get cTextSecondary => AppColors.textSecondary;
  Color get cSuccess => AppColors.success;
  Color get cError => AppColors.error;
  Color get cWarning => AppColors.warning;
  Color get cInfo => AppColors.info;
}

extension YoMineroColorUtils on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color lighten([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }
}
