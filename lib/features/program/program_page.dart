import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';

/// Next step: three big choices - Sabbath programme, Yearly programme, Bulletin.
class ProgramPage extends StatelessWidget {
  const ProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(t.navProgram, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
