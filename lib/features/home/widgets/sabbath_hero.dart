import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../l10n/app_localizations.dart';
import '../home_providers.dart';
import 'sky_painter.dart';

/// Painted sky with the Sabbath countdown, and the message card laid over its
/// lower edge (overlap = depth).
class SabbathHero extends StatelessWidget {
  const SabbathHero({super.key, required this.state});

  final HomeState state;

  static const double _skyHeight = 300;
  static const double _overlap = 56;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final hm = DateFormat.Hm(Localizations.localeOf(context).toString());
    final night = state.phase == SabbathPhase.sabbath;

    final eyebrow = night
        ? t.homeSabbathEndsAt(hm.format(state.sabbathEnd))
        : t.homeSabbathBeginsAt(hm.format(state.sabbathStart));

    final label = switch (state.countdownUnit) {
      CountdownUnit.days => t.homeDaysToSabbath(state.countdownValue),
      CountdownUnit.hours => t.homeHoursToSabbath(state.countdownValue),
      CountdownUnit.minutes => t.homeMinutesToSabbath(state.countdownValue),
    };

    const shadow = [Shadow(color: Color(0x59000000), blurRadius: 10, offset: Offset(0, 2))];

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: _skyHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), boxShadow: depth(3)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(
                painter: SkyPainter(progress: state.sunProgress, night: night),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eyebrow,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: shadow,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (night)
                        Text(
                          t.homeHappySabbath,
                          style: serif(
                            44,
                            color: Colors.white,
                            height: 1.1,
                          ).copyWith(shadows: shadow),
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${state.countdownValue}',
                              style: serif(
                                76,
                                color: Colors.white,
                                height: 1,
                              ).copyWith(shadows: shadow),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  shadows: shadow,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: _skyHeight - _overlap, left: 14, right: 14),
          child: _MessageCard(message: state.message),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final SabbathMessage message;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPaper.sheet,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPaper.edge),
        boxShadow: depth(2),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.homeSabbathMessage.toUpperCase(),
                  style: tt.bodyMedium?.copyWith(
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(right: 36),
                  child: Text(message.theme, style: serif(28, color: AppPaper.ink, height: 1.15)),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message.scripture,
                        style: tt.titleMedium?.copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Text(message.speaker, style: tt.bodyLarge),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            right: 24,
            child: CustomPaint(size: Size(26, 62), painter: _RibbonPainter()),
          ),
        ],
      ),
    );
  }
}

/// A bookmark ribbon hanging from the top edge of the card.
class _RibbonPainter extends CustomPainter {
  const _RibbonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, size.height - 12)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawShadow(path, Colors.black, 3, false);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8A2346), Color(0xFF6E1A38)],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
