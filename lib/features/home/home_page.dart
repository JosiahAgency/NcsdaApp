import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/typography.dart';
import '../../l10n/app_localizations.dart';
import '../program/widgets/event_sheet.dart';
import 'home_providers.dart';
import 'widgets/coming_up_card.dart';
import 'widgets/give_button.dart';
import 'widgets/sabbath_card.dart';

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
                    const Icon(Icons.church_outlined, size: 40, color: AppColors.navy),
              ),
              const SizedBox(width: 12),
              Text(t.appName, style: heading(22, color: AppColors.ink)),
            ],
          ),
          const SizedBox(height: 18),
          SabbathCard(
            state: state,
            onOrderOfService: () => tabs.select(1),
            onBulletin: () => tabs.select(1),
          ),
          const SizedBox(height: 18),
          GiveButton(onTap: () => tabs.select(2), title: t.navGive, subtitle: t.homeGiveSubtitle),
          if (state.upcoming.isNotEmpty) ...[
            const SizedBox(height: 22),
            ComingUpCard(items: state.upcoming, onItemTap: (e) => showEventSheet(context, e)),
          ],
        ],
      ),
    );
  }
}
