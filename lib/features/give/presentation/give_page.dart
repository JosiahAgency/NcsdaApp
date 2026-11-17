import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/format.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/give_models.dart';
import 'give_view_model.dart';

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
      child: switch (s.stage) {
        GiveStage.choose => _ChooseStep(state: s, vm: vm),
        GiveStage.details => _DetailsStep(state: s, vm: vm),
        GiveStage.paying => _PayingStep(state: s, vm: vm),
        GiveStage.done => _DoneStep(vm: vm),
      },
    );
  }
}

// ---------- Step 1: choose ----------
class _ChooseStep extends StatelessWidget {
  const _ChooseStep({required this.state, required this.vm});

  final GiveState state;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: [
              Text(t.giveTitle, style: tt.headlineMedium),
              const SizedBox(height: 8),
              Text(t.giveIntro, style: tt.bodyLarge),
              const SizedBox(height: 20),
              for (final c in state.categories) ...[
                _AmountCard(
                  key: ValueKey(c.id),
                  name: c.name(lang),
                  initial: state.amounts[c.id] ?? 0,
                  onChanged: (v) => vm.setAmount(c.id, v),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        _BottomBar(
          total: state.total,
          totalLabel: t.totalLabel,
          child: FilledButton(
            onPressed: state.total > 0 ? vm.toDetails : null,
            child: Text(t.continueLabel),
          ),
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    super.key,
    required this.name,
    required this.initial,
    required this.onChanged,
  });

  final String name;
  final int initial;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(width: 12),
          SizedBox(
            width: 150,
            child: TextFormField(
              initialValue: initial == 0 ? '' : '$initial',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: const InputDecoration(hintText: '0', prefixText: 'KES '),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Step 2: details ----------
class _DetailsStep extends StatelessWidget {
  const _DetailsStep({required this.state, required this.vm});

  final GiveState state;
  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final lang = Localizations.localeOf(context).languageCode;
    final phoneError = state.phone.length >= 10 && state.normalizedPhone == null
        ? t.phoneInvalid
        : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: [
              Text(t.giveTitle, style: tt.headlineMedium),
              const SizedBox(height: 16),
              SoftCard(
                child: Column(
                  children: [
                    for (final l in state.lines)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(l.category.name(lang), style: tt.bodyLarge)),
                            Text(formatKes(l.amount), style: tt.titleMedium),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!vm.usesWebCheckout) ...[
                const SizedBox(height: 24),
                Text(t.payWith, style: tt.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<PaymentMethod>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    segments: [
                      ButtonSegment(value: PaymentMethod.mpesa, label: Text(t.mpesa)),
                      ButtonSegment(value: PaymentMethod.airtel, label: Text(t.airtel)),
                    ],
                    selected: {state.method},
                    onSelectionChanged: (v) => vm.setMethod(v.first),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: state.phone,
                  keyboardType: TextInputType.phone,
                  style: tt.titleMedium,
                  decoration: InputDecoration(
                    labelText: t.phoneLabel,
                    helperText: t.phoneHelp,
                    helperMaxLines: 2,
                    errorText: phoneError,
                  ),
                  onChanged: vm.setPhone,
                ),
              ],
            ],
          ),
        ),
        _BottomBar(
          total: state.total,
          totalLabel: t.totalLabel,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: vm.canPay ? vm.pay : null,
                child: Text(
                  vm.usesWebCheckout ? t.webCheckoutButton : t.payButton(formatKes(state.total)),
                ),
              ),
              TextButton(onPressed: vm.backToChoose, child: Text(t.back)),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------- Step 3: paying (one prompt at a time) ----------
class _PayingStep extends StatelessWidget {
  const _PayingStep({required this.state, required this.vm});

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
                        children: [
                          SizedBox(width: 32, child: _StatusIcon(status)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${l.category.name(lang)}\n${formatKes(l.amount)}',
                              style: tt.bodyLarge,
                            ),
                          ),
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

// ---------- Step 4: done ----------
class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.vm});

  final GiveViewModel vm;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 96),
          const SizedBox(height: 24),
          Text(t.thankYou, style: tt.headlineMedium),
          const SizedBox(height: 12),
          Text(t.thankYouBody, style: tt.bodyLarge, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          FilledButton(onPressed: vm.reset, child: Text(t.done)),
        ],
      ),
    );
  }
}

// ---------- shared ----------
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.total, required this.totalLabel, required this.child});

  final int total;
  final String totalLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(totalLabel, style: tt.titleMedium),
              Text(formatKes(total), style: tt.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
