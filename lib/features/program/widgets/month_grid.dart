import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/dates.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/ink_surface.dart';
import '../../../core/widgets/raised_tap.dart';
import '../../../core/widgets/text_scale.dart';

/// Month at a glance. The Sabbath column is tinted so it always stands out.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.weeks,
    required this.today,
    required this.selected,
    required this.countOn,
    required this.onTap,
  });

  final List<List<DateTime?>> weeks;
  final DateTime today;
  final DateTime selected;
  final int Function(DateTime) countOn;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final weekday = DateFormat.E(Localizations.localeOf(context).toString());
    final headerDays = weekDaysOf(weeks.first.firstWhere((d) => d != null)!);

    return CappedTextScale(
      max: 1.2,
      child: InkSurface(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: depth(1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                for (final d in headerDays)
                  Expanded(
                    child: Center(
                      child: Text(
                        weekday.format(d),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: d.weekday == DateTime.saturday
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: d.weekday == DateTime.saturday
                              ? AppColors.navy
                              : AppColors.ink.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            for (final week in weeks)
              Row(
                children: [
                  for (final day in week)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: day == null
                            ? const SizedBox(height: 54)
                            : _Cell(
                                day: day,
                                isSelected: isSameDay(day, selected),
                                isToday: isSameDay(day, today),
                                count: countOn(day),
                                onTap: () => onTap(day),
                              ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.count,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sabbath = day.weekday == DateTime.saturday;

    return RaisedTap(
      onTap: onTap,
      radius: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isSelected
            ? AppColors.navy
            : (sabbath ? AppColors.gold.withValues(alpha: 0.18) : Colors.transparent),
        border: isToday ? Border.all(color: AppColors.gold, width: 2.2) : null,
        boxShadow: isSelected ? depth(1) : null,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 54),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${day.day}',
                style: heading(
                  17,
                  weight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < math.min(count, 3); i++)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.navy.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
