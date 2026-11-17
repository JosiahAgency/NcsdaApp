import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Display serif for headings that should feel printed, not app-generic.
/// Same Noto family as the UI text, so it stays within the Adventist guidance.
TextStyle serif(
  double size, {
  FontWeight weight = FontWeight.w700,
  Color? color,
  double? height,
  double? letterSpacing,
}) => GoogleFonts.notoSerif(
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
  letterSpacing: letterSpacing,
);
