import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/surfaces.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/text_scale.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/give_models.dart';

/// Back link + page title shared by the steps after the first.
class GiveHeader extends StatelessWidget {
  const GiveHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          label: Text(t.back),
        ),
        const SizedBox(height: 4),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

/// Sticky bar at the foot of a step: optional total, then the main action.
class GiveBottomBar extends StatelessWidget {
  const GiveBottomBar({super.key, this.total, required this.child});

  final int? total;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (total != null) ...[
            Row(
              children: [
                Text(t.totalLabel, style: tt.titleMedium),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(formatKes(total!), textAlign: TextAlign.end, style: tt.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return TextButton.icon(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: value));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.giveCopied)));
      },
      icon: const Icon(Icons.copy_rounded, size: 20),
      label: Text(t.giveCopy),
    );
  }
}

/// A small label over a big value, with an optional Copy button.
/// The value shrinks to fit rather than overflowing (long account numbers).
class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value, this.copyValue});

  final String label;
  final String value;
  final String? copyValue;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.ink.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: heading(22, color: AppPaper.ink)),
        ),
      ],
    );

    if (copyValue == null) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: text);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: isLargeText(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text,
                CopyButton(value: copyValue!),
              ],
            )
          : Row(
              children: [
                Expanded(child: text),
                CopyButton(value: copyValue!),
              ],
            ),
    );
  }
}

/// The paybill (or account) number on cream paper, with Copy.
class ChannelCard extends StatelessWidget {
  const ChannelCard({super.key, required this.channel});

  final GivingChannel channel;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppPaper.sheet,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPaper.edge),
        boxShadow: depth(1),
      ),
      child: DetailRow(label: t.givePaybill, value: channel.number, copyValue: channel.number),
    );
  }
}

/// "Account: TITHE" - the account the money will be labelled with.
class AccountTag extends StatelessWidget {
  const AccountTag({super.key, required this.account});

  final String account;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.mist.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        t.giveAccountLabel(account),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy),
      ),
    );
  }
}
