import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Set to a fixed moment to preview a phase while designing (then hot restart):
///   DateTime(2026, 11, 18, 9, 0)   -> midweek, Sabbath is 2 days away
///   DateTime(2026, 11, 20, 17, 45) -> Friday, 38 minutes before Sabbath
///   DateTime(2026, 11, 21, 10, 15) -> Sabbath morning, Divine Service is live
/// Leave null to use the real clock.
const DateTime? kPreviewNow = null;

DateTime _now() => kPreviewNow ?? DateTime.now();

// Dummy values. Later: sunset time per week from the API.
const _sabbathLength = Duration(hours: 23, minutes: 57);

enum SabbathPhase { week, eve, sabbath }

enum CountdownUnit { days, hours, minutes }

class ProgramItem {
  const ProgramItem({
    required this.start,
    required this.end,
    required this.title,
    required this.place,
  });

  final DateTime start;
  final DateTime end;
  final String title;
  final String place;

  bool isLiveAt(DateTime now) => !now.isBefore(start) && now.isBefore(end);
}

class SabbathMessage {
  const SabbathMessage({required this.theme, required this.scripture, required this.speaker});

  final String theme;
  final String scripture;
  final String speaker;
}

class BulletinInfo {
  const BulletinInfo({required this.date, required this.pages});

  final DateTime date;
  final int pages;
}

class HomeState {
  const HomeState({
    required this.now,
    required this.phase,
    required this.sabbathStart,
    required this.sabbathEnd,
    required this.countdownValue,
    required this.countdownUnit,
    required this.sunProgress,
    required this.message,
    required this.upcoming,
    required this.bulletin,
  });

  final DateTime now;
  final SabbathPhase phase;
  final DateTime sabbathStart;
  final DateTime sabbathEnd;
  final int countdownValue;
  final CountdownUnit countdownUnit;

  /// 0 = bright morning sky, 1 = sunset. Drives the hero illustration.
  final double sunProgress;
  final SabbathMessage message;
  final List<ProgramItem> upcoming;
  final BulletinInfo bulletin;
}

DateTime _sabbathStartFor(DateTime now) {
  final daysToFriday = (DateTime.friday - now.weekday) % 7;
  var start = DateTime(now.year, now.month, now.day + daysToFriday, 18, 23);
  final previous = start.subtract(const Duration(days: 7));
  if (now.isBefore(previous.add(_sabbathLength))) start = previous;
  return start;
}

HomeState composeHome(DateTime now) {
  final start = _sabbathStartFor(now);
  final end = start.add(_sabbathLength);
  final diff = start.difference(now);

  final phase = !now.isBefore(start)
      ? SabbathPhase.sabbath
      : (diff < const Duration(hours: 6) ? SabbathPhase.eve : SabbathPhase.week);

  final remaining = phase == SabbathPhase.sabbath ? Duration.zero : diff;
  late final CountdownUnit unit;
  late final int value;
  if (remaining.inHours >= 24) {
    unit = CountdownUnit.days;
    value = remaining.inDays;
  } else if (remaining.inMinutes >= 60) {
    unit = CountdownUnit.hours;
    value = remaining.inHours;
  } else {
    unit = CountdownUnit.minutes;
    value = remaining.inMinutes < 1 ? 1 : remaining.inMinutes;
  }

  double sun;
  if (phase == SabbathPhase.sabbath) {
    sun = 1;
  } else {
    final span = const Duration(days: 6).inMinutes;
    final p = 1 - (diff.inMinutes / span).clamp(0.0, 1.0).toDouble();
    sun = 0.1 + 0.85 * p;
  }

  DateTime at(int dayOffset, int h, int m) =>
      DateTime(start.year, start.month, start.day + dayOffset, h, m);

  final all = <ProgramItem>[
    ProgramItem(
      start: at(-2, 17, 30),
      end: at(-2, 18, 30),
      title: 'Midweek prayer meeting',
      place: 'Fellowship hall',
    ),
    ProgramItem(
      start: at(0, 17, 30),
      end: at(0, 19, 0),
      title: 'Choir rehearsal',
      place: 'Music room',
    ),
    ProgramItem(start: at(0, 19, 0), end: at(0, 20, 0), title: 'Vespers', place: 'Main sanctuary'),
    ProgramItem(
      start: at(1, 7, 50),
      end: at(1, 9, 43),
      title: 'Sabbath School',
      place: 'Main sanctuary and classrooms',
    ),
    ProgramItem(
      start: at(1, 9, 43),
      end: at(1, 12, 25),
      title: 'Divine Service',
      place: 'Main sanctuary',
    ),
    ProgramItem(
      start: at(1, 15, 0),
      end: at(1, 17, 0),
      title: 'Youth fellowship afternoon',
      place: 'Youth hall',
    ),
  ];

  return HomeState(
    now: now,
    phase: phase,
    sabbathStart: start,
    sabbathEnd: end,
    countdownValue: value,
    countdownUnit: unit,
    sunProgress: sun,
    message: const SabbathMessage(
      theme: 'Anchored in Hope',
      scripture: 'Hebrews 6:19',
      speaker: 'Pr. J. Mwangi',
    ),
    upcoming: all.where((i) => i.end.isAfter(now)).take(3).toList(),
    bulletin: BulletinInfo(date: at(1, 0, 0), pages: 6),
  );
}

/// Single source of truth for the Home screen. Ticks every minute so the
/// countdown and the "live" badge stay honest.
class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    final timer = Timer.periodic(const Duration(minutes: 1), (_) => state = composeHome(_now()));
    ref.onDispose(timer.cancel);
    return composeHome(_now());
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);
