import 'package:material_ui/material_ui.dart';

import '../../../../core/format.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/give_models.dart';
import '../give_view_model.dart';
import 'give_common.dart';

/// Step 4: one prompt at a time (proposal 3.2), so every reason lands on the
/// Paybill statement under its own account.
class PayingStep extends StatelessWidget {
  const PayingStep({super.key, required this.state, required this.vm});

  final GiveState state;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    final failed = state.lastOutcome != null;

    String label(LineStatus s) => switch (s) {
      LineStatus.paid => t.statusPaid,
      LineStatus.skipped => t.statusSkipped,
      LineStatus.waiting => t.statusWaiting,
      _ => '',
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: [
        Text(t.payStep(state.currentStep, state.lines.length), style: tt.headlineMedium),
        const SizedBox(height: 8),
        Text(t.payInstruction, style: tt.bodyLarge),
        const SizedBox(height: 20),
        SoftCard(
          child: Column(
            children: [
              for (final l in state.lines)
                Builder(
                  builder: (context) {
                    final status = state.statuses[l.category.id] ?? LineStatus.waiting;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 32, child: _StatusIcon(status)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.category.name(lang), style: tt.titleMedium),
                                Text(formatKes(l.amount), style: tt.bodyLarge),
                                const SizedBox(height: 6),
                                AccountTag(account: l.category.accountRef),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(label(status), style: tt.bodyMedium),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (failed) ...[
          const SizedBox(height: 20),
          Text(t.payFailed, style: tt.titleMedium?.copyWith(color: AppColors.danger)),
          const SizedBox(height: 12),
          FilledButton(onPressed: vm.retry, child: Text(t.tryAgain)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: vm.skipFailed, child: Text(t.skipThis)),
        ],
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon(this.status);

  final LineStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    LineStatus.paid => const Icon(Icons.check_circle, color: AppColors.success, size: 28),
    LineStatus.failed => const Icon(Icons.error, color: AppColors.danger, size: 28),
    LineStatus.skipped => const Icon(Icons.remove_circle_outline, size: 28),
    LineStatus.prompting => const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 3),
    ),
    LineStatus.waiting => const Icon(Icons.schedule, size: 28),
  };
}
