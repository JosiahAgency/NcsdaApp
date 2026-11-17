import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/raised_tap.dart';
import '../../../l10n/app_localizations.dart';
import '../home_providers.dart';

/// The bulletin as a small stack of printed sheets. Height follows the front
/// sheet, so larger system text never overflows.
class BulletinCard extends StatelessWidget {
  const BulletinCard({super.key, required this.info, required this.onTap});

  final BulletinInfo info;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final date = DateFormat('EEEE, d MMMM', Localizations.localeOf(context).toString());

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 8,
            right: 8,
            top: 10,
            bottom: -10,
            child: Transform.rotate(angle: -0.02, child: const _Sheet(color: AppPaper.sheetShade)),
          ),
          Positioned(
            left: 4,
            right: 4,
            top: 5,
            bottom: -5,
            child: Transform.rotate(angle: 0.012, child: const _Sheet(color: Color(0xFFF6EFDC))),
          ),
          RaisedTap(
            onTap: onTap,
            radius: 18,
            decoration: BoxDecoration(
              color: AppPaper.sheet,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppPaper.edge),
              boxShadow: depth(2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const _Thumb(),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.weeklyBulletin, style: serif(22, color: AppPaper.ink, height: 1.15)),
                        const SizedBox(height: 4),
                        Text(date.format(info.date), style: tt.bodyMedium),
                        Text(t.homeBulletinPages(info.pages), style: tt.bodyMedium),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              t.homeRead,
                              style: tt.titleMedium?.copyWith(color: AppColors.navy),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                              color: AppColors.navy,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppPaper.edge),
      boxShadow: depth(1),
    ),
  );
}

/// A tiny page preview: heading bar and lines of "text".
class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    Widget line(double w) => Container(
      width: w,
      height: 3,
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)),
    );

    return Transform.rotate(
      angle: -0.05,
      child: Container(
        width: 62,
        height: 82,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppPaper.edge),
          boxShadow: depth(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),
            line(46),
            line(40),
            line(46),
            line(30),
            line(44),
          ],
        ),
      ),
    );
  }
}
