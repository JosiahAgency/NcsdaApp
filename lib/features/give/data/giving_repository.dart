import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/give_models.dart';

abstract class GivingRepository {
  /// Active reasons for giving. Controlled from the admin portal, so the
  /// list can change without an app update (proposal 2.3).
  Future<List<GiveCategory>> categories();

  /// Sends ONE prompt (M-Pesa or Airtel) and resolves when the member paid,
  /// cancelled, or it timed out (proposal 3.2: guided sequential checkout).
  Future<PaymentOutcome> requestPayment({
    required GiveMethod method,
    required String phone,
    required String accountRef,
    required int amount,
  });

  /// iOS: hand the selection over to the secure web checkout (proposal 4.1).
  Uri webCheckoutUri({required List<GiveLine> lines, required GiveMethod method});
}

/// Replace with an ApiGivingRepository that talks to the Laravel API.
class FakeGivingRepository implements GivingRepository {
  @override
  Future<List<GiveCategory>> categories() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // Account references are placeholders: confirm the exact text with the
    // treasurer. Each one must be 12 characters or fewer.
    return const [
      GiveCategory(id: 'tithe', nameEn: 'Tithe', nameSw: 'Zaka', accountRef: 'TITHE'),
      GiveCategory(
        id: 'local_budget',
        nameEn: 'Local church budget',
        nameSw: 'Bajeti ya kanisa la mtaa',
        accountRef: 'LOCALBUDGET',
      ),
      GiveCategory(
        id: 'evangelism',
        nameEn: 'Evangelism',
        nameSw: 'Uinjilisti',
        accountRef: 'EVANGELISM',
      ),
      GiveCategory(id: 'accs', nameEn: 'ACCS', nameSw: 'ACCS', accountRef: 'ACCS'),
      GiveCategory(
        id: 'camp_meeting',
        nameEn: 'Camp Meeting',
        nameSw: 'Kambi ya Mkutano',
        accountRef: 'CAMPMEETING',
      ),
      GiveCategory(
        id: 'thanksgiving',
        nameEn: 'Thanksgiving',
        nameSw: 'Shukrani',
        accountRef: 'THANKSGIVING',
      ),
    ];
  }

  @override
  Future<PaymentOutcome> requestPayment({
    required GiveMethod method,
    required String phone,
    required String accountRef,
    required int amount,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return PaymentOutcome.paid;
  }

  @override
  Uri webCheckoutUri({required List<GiveLine> lines, required GiveMethod method}) {
    return Uri.https('connect.example.or.ke', '/give', {
      'items': lines.map((l) => '${l.category.accountRef}:${l.amount}').join(','),
      'method': method.name,
    });
  }
}

final givingRepositoryProvider = Provider<GivingRepository>((ref) => FakeGivingRepository());

/// iOS uses the web checkout (proposal 4.1). Overridable in tests.
final useWebCheckoutProvider = Provider<bool>((ref) => Platform.isIOS);
