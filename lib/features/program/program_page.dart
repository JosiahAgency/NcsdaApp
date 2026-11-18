import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import 'program_provider.dart';
import 'widgets/event_sheet.dart';
import 'widgets/ministry_filter.dart';
import 'widgets/month_body.dart';
import 'widgets/week_agenda.dart';
import 'widgets/week_strip.dart';

class ProgramPage extends ConsumerWidget {
  const ProgramPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(programViewModelProvider);
    final vm = ref.read(programViewModelProvider.notifier);
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    final label = s.view == ProgramView.week
        ? _weekLabel(s.weekDays, locale)
        : DateFormat.yMMMM(locale).format(s.focused);

    Future<void> openFilter() async {
      final picked = await showMinistrySheet(
        context,
        ministries: s.ministries,
        selected: s.ministry,
      );
      if (picked != null) vm.setMinistry(picked == kAllMinistries ? null : picked);
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<ProgramView>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(minimumSize: const Size(0, 48)),
                    segments: [
                      ButtonSegment(value: ProgramView.week, label: Text(t.progWeek)),
                      ButtonSegment(value: ProgramView.month, label: Text(t.progMonth)),
                    ],
                    selected: {s.view},
                    onSelectionChanged: (v) => vm.setView(v.first),
                  ),
                ),
                if (!s.isCurrentPeriod) ...[
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    onPressed: vm.goToday,
                    child: Text(t.homeToday),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Row(
              children: [
                IconButton(
                  iconSize: 32,
                  tooltip: t.progPrevious,
                  onPressed: vm.previous,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: heading(21, color: AppColors.ink, height: 1.2),
                  ),
                ),
                IconButton(
                  iconSize: 32,
                  tooltip: t.progNext,
                  onPressed: vm.next,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          if (s.view == ProgramView.week)
            WeekStrip(
              days: s.weekDays,
              today: s.today,
              selected: s.selected,
              countOn: s.countOn,
              onTap: vm.selectDay,
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(s.view),
                child: s.view == ProgramView.week
                    ? WeekAgenda(
                        state: s,
                        onEventTap: (e) => showEventSheet(context, e),
                        onFilterTap: openFilter,
                      )
                    : MonthBody(
                        state: s,
                        onSelect: vm.selectDay,
                        onEventTap: (e) => showEventSheet(context, e),
                        onFilterTap: openFilter,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _weekLabel(List<DateTime> days, String locale) {
  final s = days.first;
  final e = days.last;
  if (s.month == e.month) {
    return '${s.day} – ${e.day} ${DateFormat.MMMM(locale).format(e)} ${e.year}';
  }
  final f = DateFormat('d MMM', locale);
  return '${f.format(s)} – ${f.format(e)} ${e.year}';
}
