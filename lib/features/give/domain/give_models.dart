/// The three ways to give. M-Pesa and Airtel Money are paid inside the app;
/// bank giving only shows the account details.
enum GiveMethod { mpesa, airtel, bank }

extension GiveMethodX on GiveMethod {
  bool get paysInApp => this != GiveMethod.bank;
}

enum LineStatus { waiting, prompting, paid, failed, skipped }

enum PaymentOutcome { paid, cancelled, timedOut, failed }

/// Where the money goes for one way of giving. Fixed by the church treasury.
class GivingChannel {
  const GivingChannel({
    required this.method,
    required this.name,
    required this.number,
    this.bankName,
  });

  final GiveMethod method;

  /// Brand name shown on the card, e.g. "M-Pesa".
  final String name;

  /// Paybill number (M-Pesa, Airtel) or bank account number.
  final String number;
  final String? bankName;
}

// Proposal 2.1: payments go to the church's existing Paybill number(s).
// Later these can come from the API; they rarely change.
const kGivingChannels = <GiveMethod, GivingChannel>{
  GiveMethod.mpesa: GivingChannel(method: GiveMethod.mpesa, name: 'M-Pesa', number: '320100'),
  GiveMethod.airtel: GivingChannel(
    method: GiveMethod.airtel,
    name: 'Airtel Money',
    number: 'SDA01',
  ),
  GiveMethod.bank: GivingChannel(
    method: GiveMethod.bank,
    name: 'Stanbic Bank',
    number: '0102024184600',
    bankName: 'Stanbic Bank',
  ),
};

/// A reason for giving. [accountRef] is the Paybill "Account" the money is
/// labelled with, and the reference to write on a bank transfer.
class GiveCategory {
  const GiveCategory({
    required this.id,
    required this.nameEn,
    required this.nameSw,
    required this.accountRef,
  }) : assert(accountRef.length <= 12, 'Safaricom limits the account reference to 12 characters');

  final String id;
  final String nameEn;
  final String nameSw;
  final String accountRef;

  String name(String languageCode) => languageCode == 'sw' ? nameSw : nameEn;
}

class GiveLine {
  const GiveLine(this.category, this.amount);

  final GiveCategory category;
  final int amount;
}

/// Accepts 07xx, 01xx, 7xx, 254... and +254...; returns 2547xxxxxxxx / 2541xxxxxxxx or null.
String? normalizeKenyanPhone(String raw) {
  var d = raw.replaceAll(RegExp(r'\D'), '');
  if (d.length == 12 && d.startsWith('254')) {
    // already international
  } else if (d.length == 10 && d.startsWith('0')) {
    d = '254${d.substring(1)}';
  } else if (d.length == 9 && (d.startsWith('7') || d.startsWith('1'))) {
    d = '254$d';
  } else {
    return null;
  }
  return RegExp(r'^254[17]\d{8}$').hasMatch(d) ? d : null;
}
