import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/dates.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/ink_surface.dart';
import '../../../core/widgets/time_row.dart';
import '../../../l10n/app_localizations.dart';
import '../program_provider.dart';

/// One day's programme. Sabbath days are printed on cream paper.
class DayGroupCard extends StatelessWidget {
  const DayGroupCard({
    super.key,
    required this.day,
    required this.events,
    required this.today,
    required this.now,
    required this.onEventTap,
  });

  final DateTime day;
  final List<ProgramEvent> events;
  final DateTime today;
  final DateTime now;
  final ValueChanged<ProgramEvent> onEventTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final sabbath = day.weekday == DateTime.saturday;
    final rule = sabbath ? AppPaper.edge : AppColors.line;

    return InkSurface(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      decoration: BoxDecoration(
        color: sabbath ? AppPaper.sheet : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: sabbath ? Border.all(color: AppPaper.edge) : null,
        boxShadow: depth(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                DateFormat('EEEE, d MMMM', locale).format(day),
                style: heading(20, color: AppPaper.ink),
              ),
              if (sabbath)
                _Tag(label: t.progSabbath, background: AppColors.navy, foreground: Colors.white),
              if (isSameDay(day, today))
                _Tag(label: t.homeToday, background: AppColors.gold, foreground: AppColors.navy),
            ],
          ),
          Divider(height: 22, color: rule),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(t.progNothingDay, style: tt.bodyLarge),
            )
          else
            for (var i = 0; i < events.length; i++) ...[
              if (i > 0) Divider(height: 1, color: rule),
              _EventTile(
                event: events[i],
                past: events[i].end.isBefore(now),
                onTap: () => onEventTap(events[i]),
              ),
            ],
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, required this.past, required this.onTap});

  final ProgramEvent event;
  final bool past;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hm = DateFormat.Hm(Localizations.localeOf(context).toString());
    final muted = AppColors.ink.withValues(alpha: 0.65);

    return Opacity(
      opacity: past ? 0.55 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: TimeRow(
            time: hm.format(event.start),
            caption: hm.format(event.end),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: tt.titleMedium),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.place_outlined, size: 18, color: muted),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(event.place, style: tt.bodyMedium?.copyWith(color: muted)),
                        ),
                      ],
                    ),
                    _Tag(
                      label: event.ministry,
                      background: AppColors.mist.withValues(alpha: 0.6),
                      foreground: AppColors.navy,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.background, required this.foreground});

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: foreground),
      ),
    );
  }
}
