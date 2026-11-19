import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/soft_card.dart';
import '../../../../core/widgets/text_scale.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/give_models.dart';
import '../give_view_model.dart';
import 'give_common.dart';

/// Step 2 (M-Pesa / Airtel): an amount next to each reason (proposal 2.1:
/// several reasons can be combined in one session).
class AmountsStep extends StatelessWidget {
  const AmountsStep({super.key, required this.state, required this.vm});

  final GiveState state;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme
        .of(context)
        .textTheme;
    final lang = Localizations
        .localeOf(context)
        .languageCode;
    final channel = state.channel!;

    return Column(children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            GiveHeader(title: t.giveBy(channel.name), onBack: vm.backToMethods),
            const SizedBox(height: 14),
            ChannelCard(channel: channel),
            const SizedBox(height: 18),
            Text(t.giveAmountsIntro, style: tt.bodyLarge),
            const SizedBox(height: 14),
            for (final c in state.categories) ...[
              _AmountCard(
                key: ValueKey(c.id),
                category: c,
                name: c.name(lang),
                initial: state.amounts[c.id] ?? 0,
                onChanged: (v) => vm.setAmount(c.id, v),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      GiveBottomBar(
        total: state.total,
        child: FilledButton(
          onPressed: state.total > 0 ? vm.toDetails : null,
          child: Text(t.continueLabel),
        ),
      ),
    ]);
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    super.key,
    required this.category,
    required this.name,
    required this.initial,
    required this.onChanged,
  });

  final GiveCategory category;
  final String name;
  final int initial;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme
        .of(context)
        .textTheme;
    final field = TextFormField(
      initialValue: initial == 0 ? '' : '$initial',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.end,
      style: tt.titleMedium,
      decoration: const InputDecoration(hintText: '0', prefixText: 'KES '),
      onChanged: onChanged,
    );
    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: tt.titleMedium),
        const SizedBox(height: 6),
        AccountTag(account: category.accountRef),
      ],
    );

    return SoftCard(
      // Large phone font size: the reason sits above a full-width field.
      child: isLargeText(context)
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [label, const SizedBox(height: 12), field],
      )
          : Row(children: [
        Expanded(child: label),
        const SizedBox(width: 12),
        SizedBox(width: 150 * math.max(1.0, textScaleOf(context)), child: field),
      ]),
    );
  }
}
