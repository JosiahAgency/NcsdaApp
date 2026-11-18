import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/surfaces.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/text_scale.dart';
import '../../../l10n/app_localizations.dart';
import '../home_providers.dart';

/// The one hero card: last/this Sabbath's message, when the next Sabbath
/// begins, and the two ways into the programme.
class SabbathCard extends StatelessWidget {
  const SabbathCard({
    super.key,
    required this.state,
    required this.onOrderOfService,
    required this.onBulletin,
  });

  final HomeState state;
  final VoidCallback onOrderOfService;
  final VoidCallback onBulletin;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat('EEEE, d MMMM', locale);

    final msg = state.message;
    final dateLine = state.messageIsCurrent
        ? t.homeThisSabbathOn(dateFmt.format(state.messageDate))
        : t.homeLastSabbathOn(dateFmt.format(state.messageDate));

    // "Anchored in Hope" -> light "Anchored in" + big bold "Hope".
    final words = msg.theme.trim().split(' ');
    final lead = words.length > 1 ? words.sublist(0, words.length - 1).join(' ') : '';
    final last = words.last;

    final beginsDay = DateFormat.EEEE(locale).format(state.nextSabbathBegins);
    final beginsTime = DateFormat.Hm(locale).format(state.nextSabbathBegins);

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), boxShadow: depth(3)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF15356B), AppColors.navy],
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.occasion != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_awesome, size: 18, color: AppColors.navy),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    msg.occasion!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Text(
                          dateLine,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CappedTextScale(
                          max: 1.25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (lead.isNotEmpty)
                                Text(
                                  lead,
                                  style: heading(
                                    30,
                                    weight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.15,
                                  ),
                                ),
                              Text(last, style: heading(48, color: Colors.white, height: 1.05)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                msg.scripture,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            Text(
                              msg.speaker,
                              style: const TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ],
                        ),
                        const Divider(height: 34, color: Colors.white24),
                        Text(
                          t.homeNextSabbathOn(dateFmt.format(state.nextSabbathDate)),
                          style: const TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          state.programmeOut ? t.homeProgrammeIsOut : t.homeProgrammeOutWednesday,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.sabbathBegins,
                          style: const TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: beginsTime,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: '  $beginsDay',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.navy,
                            minimumSize: const Size(0, 56),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                          ),
                          onPressed: onOrderOfService,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(t.orderOfService),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 22),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.7),
                              width: 1.5,
                            ),
                            minimumSize: const Size(0, 56),
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                          ),
                          onPressed: onBulletin,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(t.weeklyBulletin),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 22),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const _GoldBand(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The gold edge of the card, with the Adventist symbol at the foot.
class _GoldBand extends StatelessWidget {
  const _GoldBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE2C98F), AppColors.gold, Color(0xFFC6A45E)],
        ),
        boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(-2, 0))],
      ),
      // White version of the symbol. If the asset is a filled disc, swap in the
      // plain white symbol file from adventist.design.
      child: Image.asset(
        'assets/images/round/adventist-symbol-circle--black.png',
        width: 32,
        color: Colors.white,
        colorBlendMode: BlendMode.srcIn,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
