DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// Weeks start on Sunday, so the Sabbath (Saturday) is always the last day.
DateTime startOfWeek(DateTime d) => DateTime(d.year, d.month, d.day - (d.weekday % 7));

List<DateTime> weekDaysOf(DateTime anyDay) {
  final s = startOfWeek(anyDay);
  return [for (var i = 0; i < 7; i++) DateTime(s.year, s.month, s.day + i)];
}

/// Sunday-first weeks covering [month]; cells outside the month are null.
List<List<DateTime?>> monthGrid(DateTime month) {
  final daysIn = DateTime(month.year, month.month + 1, 0).day;
  final lead = DateTime(month.year, month.month, 1).weekday % 7;
  final cells = <DateTime?>[
    for (var i = 0; i < lead; i++) null,
    for (var d = 1; d <= daysIn; d++) DateTime(month.year, month.month, d),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return [for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7)];
}
