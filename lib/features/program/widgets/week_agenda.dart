import 'package:material_ui/material_ui.dart';

import '../../../core/dates.dart';
import '../../../l10n/app_localizations.dart';
import '../program_provider.dart';
import 'day_group_card.dart';
import 'ministry_filter.dart';

/// The default view: every day of the week that has something on, as a
/// scrolling list. Tapping a day chip scrolls to that day.
class WeekAgenda extends StatefulWidget {
  const WeekAgenda({
    super.key,
    required this.state,
    required this.onEventTap,
    required this.onFilterTap,
  });

  final ProgramState state;
  final ValueChanged<ProgramEvent> onEventTap;
  final VoidCallback onFilterTap;

  @override
  State<WeekAgenda> createState() => _WeekAgendaState();
}

class _WeekAgendaState extends State<WeekAgenda> {
  final _scroll = ScrollController();
  final _keys = <DateTime, GlobalKey>{};

  @override
  void didUpdateWidget(WeekAgenda old) {
    super.didUpdateWidget(old);
    final s = widget.state;
    final o = old.state;
    if (!isSameDay(startOfWeek(s.focused), startOfWeek(o.focused))) {
      if (_scroll.hasClients) _scroll.jumpTo(0);
    } else if (!isSameDay(s.selected, o.selected)) {
      final ctx = _keys[dateOnly(s.selected)]?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final s = widget.state;
    final groups = s.weekGroups;

    return SingleChildScrollView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: MinistryPill(
              label: s.ministry ?? t.progAllMinistries,
              active: s.ministry != null,
              onTap: widget.onFilterTap,
            ),
          ),
          const SizedBox(height: 16),
          if (groups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(t.progNothingWeek, style: tt.bodyLarge, textAlign: TextAlign.center),
              ),
            )
          else
            for (final g in groups)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: KeyedSubtree(
                  key: _keys.putIfAbsent(dateOnly(g.key), GlobalKey.new),
                  child: DayGroupCard(
                    day: g.key,
                    events: g.value,
                    today: s.today,
                    now: s.now,
                    onEventTap: widget.onEventTap,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
