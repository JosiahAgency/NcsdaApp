import 'package:material_ui/material_ui.dart';

/// Warm "printed paper" tones for the bulletin and programme cards.
class AppPaper {
  static const sheet = Color(0xFFFBF6EA);
  static const sheetShade = Color(0xFFF1E9D3);
  static const edge = Color(0xFFE2D7BC);
  static const ink = Color(0xFF2A2418);
}

/// Two-layer shadow (tight contact shadow + wide ambient) so cards sit ON the page
/// instead of glowing around it. level: 1 (resting) .. 3 (lifted).
List<BoxShadow> depth(int level, {Color tint = const Color(0xFF0E2A57)}) {
  const contact = [2.0, 4.0, 6.0];
  const ambient = [10.0, 22.0, 36.0];
  const lift = [4.0, 10.0, 18.0];
  final i = (level - 1).clamp(0, 2);
  return [
    BoxShadow(
      color: tint.withValues(alpha: 0.14),
      blurRadius: contact[i],
      offset: Offset(0, contact[i] / 2),
    ),
    BoxShadow(
      color: tint.withValues(alpha: 0.16),
      blurRadius: ambient[i],
      offset: Offset(0, lift[i]),
    ),
  ];
}
