import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/give_models.dart';

abstract class GivingRepository {
  /// Active giving funds, controlled from the admin portal.
  Future<List<GiveCategory>> categories();

  /// Sends ONE STK prompt and resolves when the member paid, cancelled or it timed out.
  Future<PaymentOutcome> requestPayment({
    required PaymentMethod method,
    required String phone,
    required String accountRef,
    required int amount,
  });

  /// iOS: hand the cart off to the secure web checkout.
  Uri webCheckoutUri({required List<GiveLine> lines, required PaymentMethod method});
}

/// Replace with an ApiGivingRepository that talks to the Laravel API.
class FakeGivingRepository implements GivingRepository {
  @override
  Future<List<GiveCategory>> categories() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      GiveCategory(id: 'tithe', nameEn: 'Tithe', nameSw: 'Zaka', accountRef: 'TITHE'),
      GiveCategory(
        id: 'offering',
        nameEn: 'Combined Offering',
        nameSw: 'Sadaka ya Pamoja',
        accountRef: 'OFFERING',
      ),
      GiveCategory(
        id: 'sabbath_school',
        nameEn: 'Sabbath School',
        nameSw: 'Shule ya Sabato',
        accountRef: 'SABBATHSCH',
      ),
      GiveCategory(
        id: 'development',
        nameEn: 'Church Development',
        nameSw: 'Maendeleo ya Kanisa',
        accountRef: 'DEV',
      ),
      GiveCategory(id: 'youth', nameEn: 'Youth (AY)', nameSw: 'Vijana (AY)', accountRef: 'YOUTH'),
      GiveCategory(
        id: 'camp',
        nameEn: 'Camp Meeting',
        nameSw: 'Kambi ya Mkutano',
        accountRef: 'CAMP',
      ),
    ];
  }

  @override
  Future<PaymentOutcome> requestPayment({
    required PaymentMethod method,
    required String phone,
    required String accountRef,
    required int amount,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return PaymentOutcome.paid;
  }

  @override
  Uri webCheckoutUri({required List<GiveLine> lines, required PaymentMethod method}) {
    return Uri.https('connect.example.or.ke', '/give', {
      'items': lines.map((l) => '${l.category.accountRef}:${l.amount}').join(','),
      'method': method.name,
    });
  }
}

final givingRepositoryProvider = Provider<GivingRepository>((ref) => FakeGivingRepository());

/// Overridable in tests.
final useWebCheckoutProvider = Provider<bool>((ref) => Platform.isIOS);
