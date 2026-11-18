import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/widgets/ink_surface.dart';
import '../../../core/widgets/time_row.dart';
import '../../../l10n/app_localizations.dart';
import '../../program/program_provider.dart';

/// The next few programmes: time with weekday, title, place.
class ComingUpCard extends StatelessWidget {
  const ComingUpCard({super.key, required this.items, required this.onItemTap});

  final List<ProgramEvent> items;
  final ValueChanged<ProgramEvent> onItemTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final hm = DateFormat.Hm(locale);
    final weekday = DateFormat.E(locale);
    final muted = AppColors.ink.withValues(alpha: 0.65);

    return InkSurface(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: depth(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.homeComingUp, style: tt.titleLarge),
          const SizedBox(height: 4),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.line),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onItemTap(items[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: TimeRow(
                  time: hm.format(items[i].start),
                  caption: weekday.format(items[i].start),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].title, style: tt.titleMedium),
                      Text(items[i].place, style: tt.bodyMedium?.copyWith(color: muted)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
