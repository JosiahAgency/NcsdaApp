import 'package:material_ui/material_ui.dart';

import '../../../l10n/app_localizations.dart';
import '../program_provider.dart';
import 'day_group_card.dart';
import 'ministry_filter.dart';
import 'month_grid.dart';

/// Optional view: the month grid, with the picked day's programme underneath.
class MonthBody extends StatelessWidget {
  const MonthBody({
    super.key,
    required this.state,
    required this.onSelect,
    required this.onEventTap,
    required this.onFilterTap,
  });

  final ProgramState state;
  final ValueChanged<DateTime> onSelect;
  final ValueChanged<ProgramEvent> onEventTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MinistryPill(
            label: state.ministry ?? t.progAllMinistries,
            active: state.ministry != null,
            onTap: onFilterTap,
          ),
          const SizedBox(height: 16),
          MonthGrid(
            weeks: state.monthWeeks,
            today: state.today,
            selected: state.selected,
            countOn: state.countOn,
            onTap: onSelect,
          ),
          const SizedBox(height: 18),
          DayGroupCard(
            day: state.selected,
            events: state.eventsOn(state.selected),
            today: state.today,
            now: state.now,
            onEventTap: onEventTap,
          ),
        ],
      ),
    );
  }
}
