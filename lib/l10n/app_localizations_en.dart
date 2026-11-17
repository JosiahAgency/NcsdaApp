// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nairobi Central';

  @override
  String get navHome => 'Home';

  @override
  String get navProgram => 'Programme';

  @override
  String get navGive => 'Give';

  @override
  String get navMore => 'More';

  @override
  String get thisSabbath => 'This Sabbath';

  @override
  String get sabbathBegins => 'Sabbath begins';

  @override
  String get orderOfService => 'Order of service';

  @override
  String get weeklyBulletin => 'Weekly bulletin';

  @override
  String get giveTitle => 'Give';

  @override
  String get giveIntro =>
      'Enter an amount next to what you would like to give.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get totalLabel => 'Total';

  @override
  String get payWith => 'Pay with';

  @override
  String get mpesa => 'M-Pesa';

  @override
  String get airtel => 'Airtel Money';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHelp => 'The number that will receive the payment prompt';

  @override
  String get phoneInvalid => 'Please check the phone number';

  @override
  String payButton(String amount) {
    return 'Pay $amount';
  }

  @override
  String get webCheckoutButton => 'Continue to secure checkout';

  @override
  String get back => 'Back';

  @override
  String payStep(int current, int total) {
    return 'Payment $current of $total';
  }

  @override
  String get payInstruction => 'Check your phone and enter your PIN.';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String get payFailed => 'That payment did not go through.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get skipThis => 'Skip this one';

  @override
  String get thankYou => 'Thank you';

  @override
  String get thankYouBody =>
      'Your giving has been received. A confirmation SMS will arrive on your phone.';

  @override
  String get done => 'Done';

  @override
  String get loadFailed => 'Could not load. Please try again.';

  @override
  String get language => 'Language';

  @override
  String get homeHappySabbath => 'Happy Sabbath';

  @override
  String get homeSabbathMessage => 'Sabbath message';

  @override
  String homeSabbathBeginsAt(String time) {
    return 'Sabbath begins Friday at $time';
  }

  @override
  String homeSabbathEndsAt(String time) {
    return 'Sabbath ends at $time';
  }

  @override
  String homeDaysToSabbath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days to Sabbath',
      one: 'day to Sabbath',
    );
    return '$_temp0';
  }

  @override
  String homeHoursToSabbath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hours to Sabbath',
      one: 'hour to Sabbath',
    );
    return '$_temp0';
  }

  @override
  String homeMinutesToSabbath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'minutes to Sabbath',
      one: 'minute to Sabbath',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Coming up';

  @override
  String get homeToday => 'Today';

  @override
  String get homeNow => 'Now';

  @override
  String get homeRead => 'Read';

  @override
  String homeBulletinPages(int pages) {
    String _temp0 = intl.Intl.pluralLogic(
      pages,
      locale: localeName,
      other: '$pages pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get homeGiveSubtitle => 'Tithes & offerings';
}
