import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock.dart';
import '../program/program_provider.dart';

// Dummy values. Later: sunset time and the message come from the API.
const _sabbathLength = Duration(hours: 23, minutes: 57);

class SabbathMessage {
  const SabbathMessage({
    this.occasion,
    required this.theme,
    required this.scripture,
    required this.speaker,
  });

  /// Special-day tag, e.g. "Pathfinders Sabbath".
  final String? occasion;
  final String theme;
  final String scripture;
  final String speaker;
}

class HomeState {
  const HomeState({
    required this.messageIsCurrent,
    required this.messageDate,
    required this.message,
    required this.nextSabbathDate,
    required this.nextSabbathBegins,
    required this.programmeOut,
    required this.upcoming,
  });

  /// true during the Sabbath ("This Sabbath"), otherwise it is last Sabbath's message.
  final bool messageIsCurrent;
  final DateTime messageDate;
  final SabbathMessage message;
  final DateTime nextSabbathDate;

  /// Friday sunset that starts the next Sabbath.
  final DateTime nextSabbathBegins;
  final bool programmeOut;
  final List<ProgramEvent> upcoming;
}

DateTime _sabbathStartFor(DateTime now) {
  final daysToFriday = (DateTime.friday - now.weekday) % 7;
  var start = DateTime(now.year, now.month, now.day + daysToFriday, 18, 23);
  final previous = start.subtract(const Duration(days: 7));
  if (now.isBefore(previous.add(_sabbathLength))) start = previous;
  return start;
}

HomeState composeHome(DateTime now, List<ProgramEvent> events) {
  final start = _sabbathStartFor(now);
  final inSabbath = !now.isBefore(start);

  DateTime day(DateTime d, int offset) => DateTime(d.year, d.month, d.day + offset);

  final nextStart = inSabbath ? start.add(const Duration(days: 7)) : start;
  final nextDay = day(nextStart, 1);
  final messageDay = inSabbath ? day(start, 1) : day(start, 1 - 7);
  final wednesday = day(nextStart, -2);

  return HomeState(
    messageIsCurrent: inSabbath,
    messageDate: messageDay,
    message: const SabbathMessage(
      occasion: 'Pathfinders Sabbath',
      theme: 'Anchored in Hope',
      scripture: 'Hebrews 6:19',
      speaker: 'Pr. J. Mwangi',
    ),
    nextSabbathDate: nextDay,
    nextSabbathBegins: nextStart,
    programmeOut: !now.isBefore(wednesday),
    upcoming: events.where((e) => e.end.isAfter(now)).take(4).toList(),
  );
}

/// Single source of truth for Home. "Coming up" is read from the Programme
/// data, so both screens always agree.
class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    final events = ref.watch(programViewModelProvider.select((s) => s.events));
    final timer = Timer.periodic(const Duration(minutes: 5), (_) => ref.invalidateSelf());
    ref.onDispose(timer.cancel);
    return composeHome(appNow(), events);
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);
