import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/giving_repository.dart';
import '../domain/give_models.dart';

enum GiveStage { method, amounts, details, paying, done, bank }

class GiveState {
  const GiveState({
    this.categories = const [],
    this.loading = true,
    this.loadFailed = false,
    this.amounts = const {},
    this.method,
    this.phone = '',
    this.stage = GiveStage.method,
    this.statuses = const {},
    this.lastOutcome,
    this.bankReasonId,
  });

  final List<GiveCategory> categories;
  final bool loading;
  final bool loadFailed;
  final Map<String, int> amounts;
  final GiveMethod? method;
  final String phone;
  final GiveStage stage;
  final Map<String, LineStatus> statuses;
  final PaymentOutcome? lastOutcome;
  final String? bankReasonId;

  GivingChannel? get channel => method == null ? null : kGivingChannels[method];

  /// The reason picked on the bank screen (first one until the member chooses).
  GiveCategory? get bankReason {
    if (categories.isEmpty) return null;
    return categories.firstWhere((c) => c.id == bankReasonId, orElse: () => categories.first);
  }

  List<GiveLine> get lines => [
    for (final c in categories)
      if ((amounts[c.id] ?? 0) > 0) GiveLine(c, amounts[c.id]!),
  ];

  int get total => lines.fold(0, (sum, l) => sum + l.amount);

  String? get normalizedPhone => normalizeKenyanPhone(phone);

  /// "Payment 2 of 3": lines already settled + the one in progress.
  int get currentStep {
    final settled = lines.where((l) {
      final s = statuses[l.category.id];
      return s == LineStatus.paid || s == LineStatus.skipped;
    }).length;
    return (settled + 1).clamp(1, lines.isEmpty ? 1 : lines.length);
  }

  GiveState copyWith({
    List<GiveCategory>? categories,
    bool? loading,
    bool? loadFailed,
    Map<String, int>? amounts,
    GiveMethod? method,
    String? phone,
    GiveStage? stage,
    Map<String, LineStatus>? statuses,
    PaymentOutcome? lastOutcome,
    String? bankReasonId,
    bool clearOutcome = false,
  }) => GiveState(
    categories: categories ?? this.categories,
    loading: loading ?? this.loading,
    loadFailed: loadFailed ?? this.loadFailed,
    amounts: amounts ?? this.amounts,
    method: method ?? this.method,
    phone: phone ?? this.phone,
    stage: stage ?? this.stage,
    statuses: statuses ?? this.statuses,
    lastOutcome: clearOutcome ? null : (lastOutcome ?? this.lastOutcome),
    bankReasonId: bankReasonId ?? this.bankReasonId,
  );
}

/// Single source of truth for the Give flow. The UI only renders [GiveState]
/// and calls the methods below.
class GiveViewModel extends Notifier<GiveState> {
  late GivingRepository _repo;
  late bool _useWebCheckout;
  bool _running = false;

  bool get usesWebCheckout => _useWebCheckout;

  @override
  GiveState build() {
    _repo = ref.read(givingRepositoryProvider);
    _useWebCheckout = ref.read(useWebCheckoutProvider);
    Future.microtask(_load);
    return const GiveState();
  }

  Future<void> _load() async {
    try {
      final categories = await _repo.categories();
      state = state.copyWith(categories: categories, loading: false, loadFailed: false);
    } catch (_) {
      state = state.copyWith(loading: false, loadFailed: true);
    }
  }

  void retryLoad() {
    state = state.copyWith(loading: true, loadFailed: false);
    _load();
  }

  // --- method ---
  void chooseMethod(GiveMethod method) => state = state.copyWith(
    method: method,
    stage: method.paysInApp ? GiveStage.amounts : GiveStage.bank,
  );

  void backToMethods() => state = state.copyWith(stage: GiveStage.method);

  // --- bank ---
  void selectBankReason(String id) => state = state.copyWith(bankReasonId: id);

  // --- amounts ---
  void setAmount(String categoryId, String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final value = digits.isEmpty
        ? 0
        : int.parse(digits.length > 7 ? digits.substring(0, 7) : digits);
    state = state.copyWith(amounts: {...state.amounts, categoryId: value});
  }

  void toDetails() {
    if (state.total > 0) state = state.copyWith(stage: GiveStage.details);
  }

  // --- details ---
  void setPhone(String phone) => state = state.copyWith(phone: phone);

  void backToAmounts() => state = state.copyWith(stage: GiveStage.amounts);

  bool get canPay {
    final m = state.method;
    return m != null &&
        m.paysInApp &&
        state.total > 0 &&
        (_useWebCheckout || state.normalizedPhone != null);
  }

  Future<void> pay() async {
    if (!canPay) return;
    final s = state;
    if (_useWebCheckout) {
      await launchUrl(
        _repo.webCheckoutUri(lines: s.lines, method: s.method!),
        mode: LaunchMode.externalApplication,
      );
      return;
    }
    state = s.copyWith(
      stage: GiveStage.paying,
      statuses: {for (final l in s.lines) l.category.id: LineStatus.waiting},
      clearOutcome: true,
    );
    await _runQueue();
  }

  // --- paying: one prompt at a time, so every reason lands under its own account ---
  Future<void> _runQueue() async {
    if (_running) return;
    _running = true;
    try {
      for (final line in state.lines) {
        final id = line.category.id;
        final status = state.statuses[id];
        if (status == LineStatus.paid || status == LineStatus.skipped) continue;

        _setStatus(id, LineStatus.prompting);
        PaymentOutcome outcome;
        try {
          outcome = await _repo.requestPayment(
            method: state.method!,
            phone: state.normalizedPhone!,
            accountRef: line.category.accountRef,
            amount: line.amount,
          );
        } catch (_) {
          outcome = PaymentOutcome.failed;
        }

        if (outcome == PaymentOutcome.paid) {
          _setStatus(id, LineStatus.paid);
        } else {
          _setStatus(id, LineStatus.failed);
          state = state.copyWith(lastOutcome: outcome);
          return; // wait for the member: try again or skip
        }
      }
      final anyPaid = state.statuses.values.contains(LineStatus.paid);
      state = state.copyWith(stage: anyPaid ? GiveStage.done : GiveStage.amounts);
    } finally {
      _running = false;
    }
  }

  void retry() {
    state = state.copyWith(clearOutcome: true);
    _runQueue();
  }

  void skipFailed() {
    state = state.copyWith(
      statuses: {
        for (final e in state.statuses.entries)
          e.key: e.value == LineStatus.failed ? LineStatus.skipped : e.value,
      },
      clearOutcome: true,
    );
    _runQueue();
  }

  /// Back to the start. Nothing about the gift is kept (proposal 2.1: no history).
  void reset() => state = state.copyWith(
    stage: GiveStage.method,
    amounts: const {},
    statuses: const {},
    clearOutcome: true,
  );

  void _setStatus(String id, LineStatus status) =>
      state = state.copyWith(statuses: {...state.statuses, id: status});
}

final giveViewModelProvider = NotifierProvider<GiveViewModel, GiveState>(GiveViewModel.new);
