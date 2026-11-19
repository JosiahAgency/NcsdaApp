import 'package:material_ui/material_ui.dart';

import '../../../../core/format.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../give_view_model.dart';
import 'give_common.dart';

/// Step 3 (M-Pesa / Airtel): check what is going where, add the phone number, pay.
class DetailsStep extends StatelessWidget {
  const DetailsStep({super.key, required this.state, required this.vm});

  final GiveState state;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    final channel = state.channel!;
    final phoneError = state.phone.length >= 10 && state.normalizedPhone == null
        ? t.phoneInvalid
        : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              GiveHeader(title: t.giveCheckTitle, onBack: vm.backToAmounts),
              const SizedBox(height: 14),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${channel.name} · ${t.givePaybillValue(channel.number)}',
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink.withValues(alpha: 0.65),
                      ),
                    ),
                    const Divider(height: 24, color: AppColors.line),
                    for (final l in state.lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.category.name(lang), style: tt.titleMedium),
                                  const SizedBox(height: 6),
                                  AccountTag(account: l.category.accountRef),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(formatKes(l.amount), style: tt.titleMedium),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (state.lines.length > 1) ...[
                const SizedBox(height: 14),
                Text(t.giveSequentialNote, style: tt.bodyMedium),
              ],
              if (!vm.usesWebCheckout) ...[
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: state.phone,
                  keyboardType: TextInputType.phone,
                  style: tt.titleMedium,
                  decoration: InputDecoration(
                    labelText: t.phoneLabel,
                    helperText: t.phoneHelp,
                    helperMaxLines: 3,
                    errorText: phoneError,
                  ),
                  onChanged: vm.setPhone,
                ),
              ],
            ],
          ),
        ),
        GiveBottomBar(
          total: state.total,
          child: FilledButton(
            onPressed: vm.canPay ? vm.pay : null,
            child: Text(
              vm.usesWebCheckout ? t.webCheckoutButton : t.payButton(formatKes(state.total)),
            ),
          ),
        ),
      ],
    );
  }
}
