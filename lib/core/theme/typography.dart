import 'package:material_ui/material_ui.dart';

/// The ONE typeface of the whole app: Nunito (rounded terminals, warm and very
/// readable). It is bundled in assets/fonts, so it also works offline, and
/// ThemeData(fontFamily: kFontFamily) makes every widget use it. To change the
/// font, change it here and in pubspec.yaml only.
const kFontFamily = 'Nunito';

/// Size and weight for big headings. It deliberately names no family, so it
/// always inherits the theme's single typeface.
TextStyle heading(
  double size, {
  FontWeight weight = FontWeight.w800,
  Color? color,
  double? height,
  double? letterSpacing,
}) => TextStyle(
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
  letterSpacing: letterSpacing,
);
