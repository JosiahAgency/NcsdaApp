import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/surfaces.dart';
import '../../../../core/widgets/raised_tap.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/give_models.dart';
import '../give_view_model.dart';
import 'give_common.dart';

/// Bank giving: account details only, nothing is paid inside the app.
/// The chosen reason becomes the payment reference, always visible at the
/// foot of the screen with a Copy button.
class BankStep extends StatelessWidget {
  const BankStep({super.key, required this.state, required this.vm});

  final GiveState state;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    final channel = kGivingChannels[GiveMethod.bank]!;
    final reason = state.bankReason;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              GiveHeader(title: t.giveBankTitle, onBack: vm.backToMethods),
              const SizedBox(height: 14),
              SoftCard(
                padding: const EdgeInsets.fromLTRB(18, 8, 10, 8),
                child: Column(
                  children: [
                    DetailRow(label: t.giveBankName, value: channel.bankName ?? channel.name),
                    const Divider(height: 1, color: AppColors.line),
                    DetailRow(
                      label: t.giveBankAccount,
                      value: channel.number,
                      copyValue: channel.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(t.giveBankReasonTitle, style: tt.titleLarge),
              const SizedBox(height: 4),
              Text(t.giveBankReasonHelp, style: tt.bodyLarge),
              const SizedBox(height: 12),
              for (final c in state.categories) ...[
                _ReasonTile(
                  name: c.name(lang),
                  selected: c.id == reason?.id,
                  onTap: () => vm.selectBankReason(c.id),
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              Text(t.giveBankNote, style: tt.bodyMedium),
            ],
          ),
        ),
        if (reason != null)
          GiveBottomBar(
            child: DetailRow(
              label: t.giveBankReference,
              value: reason.accountRef,
              copyValue: reason.accountRef,
            ),
          ),
      ],
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({required this.name, required this.selected, required this.onTap});

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RaisedTap(
      onTap: onTap,
      decoration: BoxDecoration(
        color: selected ? AppColors.mist.withValues(alpha: 0.7) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.navy : AppColors.line,
          width: selected ? 2 : 1,
        ),
        boxShadow: depth(1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.navy,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
          ],
        ),
      ),
    );
  }
}
