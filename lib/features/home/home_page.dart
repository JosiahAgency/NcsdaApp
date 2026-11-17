import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:ncsda_app/core/theme/app_theme.dart';
import 'package:ncsda_app/core/theme/typography.dart';

import '../../core/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'home_providers.dart';
import 'widgets/bulletin_card.dart';
import 'widgets/coming_up_card.dart';
import 'widgets/give_button.dart';
import 'widgets/sabbath_hero.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final state = ref.watch(homeViewModelProvider);
    final tabs = ref.read(tabIndexProvider.notifier);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/round/adventist-symbol-circle--black.png',
                height: 40,
                errorBuilder: (_, _, _) =>
                    Text('Nairobi Central', style: serif(18, color: AppColors.navy)),
              ),
              const SizedBox(width: 12),
              Text(t.appName, style: serif(18, color: AppColors.ink)),
            ],
          ),
          const SizedBox(height: 18),
          SabbathHero(state: state),
          const SizedBox(height: 22),
          ComingUpCard(state: state),
          const SizedBox(height: 22),
          BulletinCard(info: state.bulletin, onTap: () => tabs.select(1)),
          const SizedBox(height: 14),
          GiveButton(onTap: () => tabs.select(2), title: t.navGive, subtitle: t.homeGiveSubtitle),
        ],
      ),
    );
  }
}
