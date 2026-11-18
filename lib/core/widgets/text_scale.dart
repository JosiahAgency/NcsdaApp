import 'package:material_ui/material_ui.dart';

/// How much the phone's font-size setting enlarges text (1.0 = default size).
double textScaleOf(BuildContext context) => MediaQuery.textScalerOf(context).scale(1);

/// True when the phone's font size is set large enough that side-by-side
/// layouts get cramped. Those layouts switch to stacked ones.
bool isLargeText(BuildContext context) => textScaleOf(context) > 1.3;

/// Text inside still follows the phone's font-size setting, but only up to [max].
/// Use it on tightly packed rows (day chips, calendar cells) where unlimited
/// growth would overflow. Normal reading text should NOT be wrapped in this.
class CappedTextScale extends StatelessWidget {
  const CappedTextScale({super.key, this.max = 1.3, required this.child});

  final double max;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      MediaQuery.withClampedTextScaling(maxScaleFactor: max, child: child);
}
