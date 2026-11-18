import 'package:material_ui/material_ui.dart';

import 'typography.dart';

/// Eyeballed from the web screenshots - replace with the real tokens from the web CSS.
class AppColors {
  static const navy = Color(0xFF0E2A57);
  static const gold = Color(0xFFD4B87C);
  static const canvas = Color(0xFFF5F8F2);
  static const ink = Color(0xFF14231F);
  static const mist = Color(0xFFC9D7EC);
  static const line = Color(0xFFD9DED6);
  static const success = Color(0xFF1E6B4A);
  static const danger = Color(0xFFB3261E);
}

ThemeData buildTheme() {
  final base = ThemeData.light().textTheme.apply(
    fontFamily: kFontFamily,
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
  );

  final text = base.copyWith(
    headlineMedium: base.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w800),
    titleLarge: base.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w800),
    titleMedium: base.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, height: 1.4),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: 14, height: 1.4),
    labelLarge: base.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w800),
  );

  const scheme = ColorScheme.light(
    primary: AppColors.navy,
    onPrimary: Colors.white,
    secondary: AppColors.gold,
    onSecondary: AppColors.navy,
    secondaryContainer: AppColors.mist,
    onSecondaryContainer: AppColors.navy,
    surface: Colors.white,
    onSurface: AppColors.ink,
    error: AppColors.danger,
  );

  final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

  return ThemeData(
    useMaterial3: true,
    fontFamily: kFontFamily,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.canvas,
    textTheme: text,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: buttonShape,
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: buttonShape,
        side: const BorderSide(color: AppColors.navy, width: 1.5),
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48), textStyle: text.labelLarge),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.navy, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 76,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.mist,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      // never icon-only
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
