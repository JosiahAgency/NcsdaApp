import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../give_view_model.dart';

class DoneStep extends StatelessWidget {
  const DoneStep({super.key, required this.vm});

  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    // Scrolls, so it never overflows with a large phone font size.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 96),
            const SizedBox(height: 24),
            Text(t.thankYou, style: tt.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(t.thankYouBody, style: tt.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            FilledButton(onPressed: vm.reset, child: Text(t.done)),
          ],
        ),
      ),
    );
  }
}
