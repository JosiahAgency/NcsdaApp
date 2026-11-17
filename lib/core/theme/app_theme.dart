import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

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
  final base = GoogleFonts.notoSansTextTheme(ThemeData.light().textTheme)
      .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);

  // Larger than Material defaults: readable for 80-year-olds, still fine for 10-year-olds.
  final text = base.copyWith(
    headlineMedium: base.headlineMedium?.copyWith(fontSize: 30, fontWeight: FontWeight.w700),
    titleLarge: base.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: base.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: 18, height: 1.4),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
    labelLarge: base.labelLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
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
        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
