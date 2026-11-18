import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/dates.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/raised_tap.dart';
import '../../../core/widgets/text_scale.dart';

/// Seven day chips, Sunday to Sabbath. Dots show how much is on that day.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.days,
    required this.today,
    required this.selected,
    required this.countOn,
    required this.onTap,
  });

  final List<DateTime> days;
  final DateTime today;
  final DateTime selected;
  final int Function(DateTime) countOn;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final weekday = DateFormat.E(Localizations.localeOf(context).toString());

    return CappedTextScale(
      max: 1.2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < days.length; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
                    child: _DayChip(
                      label: weekday.format(days[i]),
                      day: days[i],
                      isSelected: isSameDay(days[i], selected),
                      isToday: isSameDay(days[i], today),
                      count: countOn(days[i]),
                      onTap: () => onTap(days[i]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.count,
    required this.onTap,
  });

  final String label;
  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sabbath = day.weekday == DateTime.saturday;
    final fg = isSelected ? Colors.white : AppColors.ink;

    return RaisedTap(
      onTap: onTap,
      radius: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1B3F7A), AppColors.navy],
              )
            : null,
        color: isSelected ? null : (sabbath ? AppPaper.sheet : Colors.white),
        border: isToday
            ? Border.all(color: AppColors.gold, width: 2.2)
            : (isSelected ? null : Border.all(color: sabbath ? AppPaper.edge : AppColors.line)),
        boxShadow: depth(isSelected ? 2 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fg.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 2),
            Text('${day.day}', style: heading(20, color: fg)),
            const SizedBox(height: 6),
            SizedBox(
              height: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < math.min(count, 3); i++)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.gold : AppColors.navy.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
