enum PaymentMethod { mpesa, airtel }

enum LineStatus { waiting, prompting, paid, failed, skipped }

enum PaymentOutcome { paid, cancelled, timedOut, failed }

class GiveCategory {
  const GiveCategory({
    required this.id,
    required this.nameEn,
    required this.nameSw,
    required this.accountRef,
  });

  final String id;
  final String nameEn;
  final String nameSw;

  /// Paybill account reference. Safaricom allows at most 12 characters.
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
