import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock.dart';
import '../../core/dates.dart';

enum ProgramView { week, month }

class ProgramEvent {
  const ProgramEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.place,
    required this.ministry,
    this.description,
  });

  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String place;
  final String ministry;
  final String? description;
}

class ProgramState {
  ProgramState({
    required this.now,
    required this.events,
    required this.view,
    required this.focused,
    required this.selected,
    this.ministry,
  });

  final DateTime now;
  final List<ProgramEvent> events;
  final ProgramView view;

  /// Any day inside the week or month being shown.
  final DateTime focused;
  final DateTime selected;

  /// null = all ministries.
  final String? ministry;

  DateTime get today => dateOnly(now);

  late final Map<DateTime, List<ProgramEvent>> _byDay = _group();
  late final List<String> ministries = (events.map((e) => e.ministry).toSet().toList()..sort());

  Map<DateTime, List<ProgramEvent>> _group() {
    final map = <DateTime, List<ProgramEvent>>{};
    for (final e in events) {
      if (ministry != null && e.ministry != ministry) continue;
      (map[dateOnly(e.start)] ??= []).add(e);
    }
    return map;
  }

  List<ProgramEvent> eventsOn(DateTime day) => _byDay[dateOnly(day)] ?? const [];

  int countOn(DateTime day) => eventsOn(day).length;

  List<DateTime> get weekDays => weekDaysOf(focused);

  List<List<DateTime?>> get monthWeeks => monthGrid(focused);

  /// Days of the focused week that have something on.
  List<MapEntry<DateTime, List<ProgramEvent>>> get weekGroups => [
    for (final d in weekDays)
      if (eventsOn(d).isNotEmpty) MapEntry(d, eventsOn(d)),
  ];

  bool get isCurrentPeriod => view == ProgramView.week
      ? weekDays.any((d) => isSameDay(d, today))
      : (focused.year == today.year && focused.month == today.month);

  ProgramState copyWith({
    ProgramView? view,
    DateTime? focused,
    DateTime? selected,
    String? ministry,
    bool clearMinistry = false,
  }) => ProgramState(
    now: now,
    events: events,
    view: view ?? this.view,
    focused: focused ?? this.focused,
    selected: selected ?? this.selected,
    ministry: clearMinistry ? null : (ministry ?? this.ministry),
  );
}

/// Single source of truth for the Programme tab.
class ProgramViewModel extends Notifier<ProgramState> {
  @override
  ProgramState build() {
    final now = appNow();
    final today = dateOnly(now);
    return ProgramState(
      now: now,
      events: _dummyEvents(),
      view: ProgramView.week,
      // week is the default
      focused: today,
      selected: today,
    );
  }

  void setView(ProgramView view) => state = state.copyWith(view: view, focused: state.selected);

  void previous() => _shift(-1);

  void next() => _shift(1);

  void _shift(int dir) {
    final s = state;
    if (s.view == ProgramView.week) {
      final d = DateTime(s.selected.year, s.selected.month, s.selected.day + 7 * dir);
      state = s.copyWith(focused: d, selected: d);
    } else {
      final first = DateTime(s.focused.year, s.focused.month + dir, 1);
      final sameAsToday = first.year == s.today.year && first.month == s.today.month;
      state = s.copyWith(focused: first, selected: sameAsToday ? s.today : first);
    }
  }

  void goToday() => state = state.copyWith(focused: state.today, selected: state.today);

  void selectDay(DateTime day) => state = state.copyWith(selected: dateOnly(day));

  void setMinistry(String? ministry) => state = ministry == null
      ? state.copyWith(clearMinistry: true)
      : state.copyWith(ministry: ministry);
}

final programViewModelProvider = NotifierProvider<ProgramViewModel, ProgramState>(
  ProgramViewModel.new,
);

// ---------------------------------------------------------------------------
// Dummy data. Later: events from the Laravel API (cached for offline use).
// ---------------------------------------------------------------------------
List<ProgramEvent> _dummyEvents() {
  final events = <ProgramEvent>[];
  var id = 0;

  void add(
    DateTime day,
    int sh,
    int sm,
    int eh,
    int em,
    String title,
    String place,
    String ministry, {
    String? description,
  }) {
    events.add(
      ProgramEvent(
        id: 'e${id++}',
        title: title,
        start: DateTime(day.year, day.month, day.day, sh, sm),
        end: DateTime(day.year, day.month, day.day, eh, em),
        place: place,
        ministry: ministry,
        description: description,
      ),
    );
  }

  final first = DateTime(2026, 1, 1);
  final last = DateTime(2027, 3, 31);
  for (var d = first; !d.isAfter(last); d = DateTime(d.year, d.month, d.day + 1)) {
    switch (d.weekday) {
      case DateTime.wednesday:
        add(d, 17, 30, 18, 30, 'Midweek prayer meeting', 'Fellowship hall', 'Prayer');
      case DateTime.friday:
        add(d, 17, 30, 19, 0, 'Choir rehearsal', 'Music room', 'Music');
        add(d, 19, 0, 20, 0, 'Vespers', 'Main sanctuary', 'Worship');
      case DateTime.saturday:
        add(d, 7, 50, 9, 43, 'Sabbath School', 'Main sanctuary and classrooms', 'Worship');
        add(d, 9, 43, 12, 25, 'Divine Service', 'Main sanctuary', 'Worship');
        add(d, 15, 0, 17, 0, 'Youth fellowship afternoon', 'Youth hall', 'Youth (AY)');
    }
  }

  add(
    DateTime(2026, 11, 22),
    14,
    0,
    16,
    0,
    'Church business meeting',
    'Main sanctuary',
    'Church business',
    description: 'Reports and decisions for the church family. All members are welcome.',
  );
  add(
    DateTime(2026, 11, 28),
    15,
    0,
    17,
    30,
    'Evangelistic campaign launch',
    'Main sanctuary',
    'Evangelism',
    description: 'Opening afternoon of the campaign. Invite a friend or neighbour.',
  );
  add(DateTime(2026, 12, 5), 15, 0, 17, 0, 'Pathfinder investiture', 'Youth hall', 'Youth (AY)');
  add(
    DateTime(2026, 12, 18),
    19,
    0,
    20,
    30,
    'Camp Meeting opening',
    'Main sanctuary',
    'Camp Meeting',
  );
  add(
    DateTime(2026, 12, 19),
    14,
    0,
    16,
    30,
    'Camp Meeting afternoon session',
    'Main sanctuary',
    'Camp Meeting',
  );
  add(
    DateTime(2026, 12, 20),
    10,
    0,
    12,
    0,
    'Camp Meeting closing',
    'Main sanctuary',
    'Camp Meeting',
  );
  add(
    DateTime(2026, 12, 26),
    9,
    43,
    12,
    25,
    'Holy Communion',
    'Main sanctuary',
    'Worship',
    description: "Foot washing and the Lord's Supper during the Divine Service.",
  );

  events.sort((a, b) => a.start.compareTo(b.start));
  return events;
}
