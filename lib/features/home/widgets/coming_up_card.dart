import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../l10n/app_localizations.dart';
import '../home_providers.dart';

class ComingUpCard extends StatelessWidget {
  const ComingUpCard({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final hm = DateFormat.Hm(locale);
    final weekday = DateFormat.E(locale);
    final today = DateTime(state.now.year, state.now.month, state.now.day);

    bool isToday(DateTime d) => DateTime(d.year, d.month, d.day) == today;

    final items = state.upcoming;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: depth(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.phase == SabbathPhase.sabbath ? t.homeToday : t.homeComingUp,
            style: tt.titleLarge,
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.line),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 74,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hm.format(items[i].start), style: serif(20, color: AppPaper.ink)),
                        Text(
                          isToday(items[i].start) ? t.homeToday : weekday.format(items[i].start),
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.ink.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(items[i].title, style: tt.titleMedium),
                            if (items[i].isLiveAt(state.now)) const _LiveBadge(),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          items[i].place,
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.ink.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
      child: Text(
        t.homeNow.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: AppColors.navy,
        ),
      ),
    );
  }
}
