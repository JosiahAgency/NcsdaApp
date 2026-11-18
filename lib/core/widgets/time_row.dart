import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/surfaces.dart';
import '../theme/typography.dart';

/// A time (with a small caption under it) beside some content. The time column
/// grows with the phone's font size, and with a very large font size the time
/// moves above the content instead, so nothing overflows.
class TimeRow extends StatelessWidget {
  const TimeRow({super.key, required this.time, required this.caption, required this.child});

  final String time;
  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final timeText = Text(time, style: heading(20, color: AppPaper.ink));
    final captionText = Text(
      caption,
      style: tt.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.ink.withValues(alpha: 0.65),
      ),
    );

    if (isLargeText(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [timeText, captionText],
          ),
          const SizedBox(height: 6),
          child,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 74 * math.max(1.0, textScaleOf(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [timeText, captionText],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

/// Helper to get the current text scale factor using modern Flutter APIs
double textScaleOf(BuildContext context) {
  return MediaQuery.textScalerOf(context).scale(1.0);
}

/// Helper to check if the user has a large text accessibility setting enabled
bool isLargeText(BuildContext context) {
  return textScaleOf(context) > 1.2;
}
