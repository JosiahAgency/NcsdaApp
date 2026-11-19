import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/app_localizations.dart';
import 'give_view_model.dart';
import 'widgets/amounts_step.dart';
import 'widgets/bank_step.dart';
import 'widgets/details_step.dart';
import 'widgets/done_step.dart';
import 'widgets/method_step.dart';
import 'widgets/paying_step.dart';

/// Give: choose how (M-Pesa, Airtel Money or bank), then follow that path.
class GivePage extends ConsumerWidget {
  const GivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(giveViewModelProvider);
    final vm = ref.read(giveViewModelProvider.notifier);
    final t = AppLocalizations.of(context)!;

    if (s.loading) return const Center(child: CircularProgressIndicator());
    if (s.loadFailed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.loadFailed,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: vm.retryLoad, child: Text(t.tryAgain)),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey(s.stage),
          child: switch (s.stage) {
            GiveStage.method => MethodStep(vm: vm),
            GiveStage.amounts => AmountsStep(state: s, vm: vm),
            GiveStage.details => DetailsStep(state: s, vm: vm),
            GiveStage.paying => PayingStep(state: s, vm: vm),
            GiveStage.done => DoneStep(vm: vm),
            GiveStage.bank => BankStep(state: s, vm: vm),
          },
        ),
      ),
    );
  }
}
