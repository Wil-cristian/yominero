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
    background: AppColors.background,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: AppColors.white,
    onSecondary: AppColors.onColor(AppColors.secondary),
  // onBackground deprecated -> use onSurface
  onBackground: AppColors.textPrimary,
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

class PalettePage extends StatelessWidget {
  const PalettePage({super.key});
  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, Color>>[
      MapEntry('primary', AppColors.primary),
      MapEntry('primaryContainer', AppColors.primaryContainer),
      MapEntry('secondary', AppColors.secondary),
      MapEntry('secondaryContainer', AppColors.secondaryContainer),
      MapEntry('background', AppColors.background),
      MapEntry('backgroundAlt', AppColors.backgroundAlt),
      MapEntry('surface', AppColors.surface),
      MapEntry('surfaceAlt', AppColors.surfaceAlt),
      MapEntry('outline', AppColors.outline),
      MapEntry('textPrimary', AppColors.textPrimary),
      MapEntry('textSecondary', AppColors.textSecondary),
      MapEntry('success', AppColors.success),
      MapEntry('successContainer', AppColors.successContainer),
      MapEntry('error', AppColors.error),
      MapEntry('errorContainer', AppColors.errorContainer),
      MapEntry('warning', AppColors.warning),
      MapEntry('warningContainer', AppColors.warningContainer),
      MapEntry('info', AppColors.info),
      MapEntry('infoContainer', AppColors.infoContainer),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Paleta de colores')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.8,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: entries.length,
        itemBuilder: (context, i) {
          final e = entries[i];
          return Container(
            decoration: BoxDecoration(
              color: e.value,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.key,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                    '#${e.value.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
