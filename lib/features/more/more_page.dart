import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_state.dart';
import '../../l10n/app_localizations.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final locale = ref.watch(localeProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(t.navMore, style: tt.headlineMedium),
          const SizedBox(height: 24),
          Text(t.language, style: tt.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'sw', label: Text('Kiswahili')),
            ],
            selected: {locale.languageCode},
            onSelectionChanged: (v) => ref.read(localeProvider.notifier).select(Locale(v.first)),
          ),
        ],
      ),
    );
  }
}
