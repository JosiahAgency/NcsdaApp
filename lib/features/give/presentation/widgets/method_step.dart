import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/surfaces.dart';
import '../../../../core/widgets/raised_tap.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/give_models.dart';
import '../give_view_model.dart';

/// Step 1: how would you like to give? Three big cards, each showing where
/// the money goes.
class MethodStep extends StatelessWidget {
  const MethodStep({super.key, required this.vm});

  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: [
        Text(t.navGive, style: tt.headlineMedium),
        const SizedBox(height: 8),
        Text(t.giveHowIntro, style: tt.bodyLarge),
        const SizedBox(height: 20),
        for (final m in GiveMethod.values) ...[
          _MethodCard(method: m, vm: vm),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 4),
        const _ReceiptNote(),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({required this.method, required this.vm});

  final GiveMethod method;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final channel = kGivingChannels[method]!;

    final (brand, icon) = switch (method) {
      GiveMethod.mpesa => (const Color(0xFF43B02A), Icons.smartphone),
      GiveMethod.airtel => (const Color(0xFFE40000), Icons.sim_card),
      GiveMethod.bank => (const Color(0xFF0033A0), Icons.account_balance),
    };
    final detail = method == GiveMethod.bank
        ? t.giveAccountValue(channel.number)
        : t.givePaybillValue(channel.number);
    final tag = method == GiveMethod.bank
        ? t.giveTagDetails
        : (vm.usesWebCheckout ? t.giveTagCheckout : t.giveTagInApp);

    return RaisedTap(
      onTap: () => vm.chooseMethod(method),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
        boxShadow: depth(1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: brand, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(channel.name, style: tt.titleLarge),
                  const SizedBox(height: 2),
                  Text(detail, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.mist.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 30, color: AppColors.navy),
          ],
        ),
      ),
    );
  }
}

/// Proposal 2.1: no accounts or giving history; the telco SMS is the receipt.
class _ReceiptNote extends StatelessWidget {
  const _ReceiptNote();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPaper.sheet,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPaper.edge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.navy),
          const SizedBox(width: 12),
          Expanded(child: Text(t.giveReceiptNote, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
