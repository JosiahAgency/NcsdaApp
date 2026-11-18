// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'Nairobi Central';

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navProgram => 'Ratiba';

  @override
  String get navGive => 'Toa';

  @override
  String get navMore => 'Zaidi';

  @override
  String get thisSabbath => 'Sabato hii';

  @override
  String get sabbathBegins => 'Sabato huanza';

  @override
  String get orderOfService => 'Ratiba ya ibada';

  @override
  String get weeklyBulletin => 'Matangazo ya wiki';

  @override
  String get giveTitle => 'Toa';

  @override
  String get giveIntro => 'Andika kiasi karibu na kile ungependa kutoa.';

  @override
  String get continueLabel => 'Endelea';

  @override
  String get totalLabel => 'Jumla';

  @override
  String get payWith => 'Lipa kwa';

  @override
  String get mpesa => 'M-Pesa';

  @override
  String get airtel => 'Airtel Money';

  @override
  String get phoneLabel => 'Namba ya simu';

  @override
  String get phoneHelp => 'Namba itakayopokea ombi la malipo';

  @override
  String get phoneInvalid => 'Tafadhali hakikisha namba ya simu';

  @override
  String payButton(String amount) {
    return 'Lipa $amount';
  }

  @override
  String get webCheckoutButton => 'Endelea kwenye malipo salama';

  @override
  String get back => 'Rudi';

  @override
  String payStep(int current, int total) {
    return 'Malipo $current kati ya $total';
  }

  @override
  String get payInstruction => 'Angalia simu yako na uweke PIN yako.';

  @override
  String get statusWaiting => 'Inasubiri';

  @override
  String get statusPaid => 'Imelipwa';

  @override
  String get statusSkipped => 'Imerukwa';

  @override
  String get payFailed => 'Malipo hayo hayakukamilika.';

  @override
  String get tryAgain => 'Jaribu tena';

  @override
  String get skipThis => 'Ruka hii';

  @override
  String get thankYou => 'Asante';

  @override
  String get thankYouBody =>
      'Utoaji wako umepokelewa. Utapata ujumbe wa uthibitisho kwenye simu yako.';

  @override
  String get done => 'Imekamilika';

  @override
  String get loadFailed => 'Imeshindwa kupakia. Tafadhali jaribu tena.';

  @override
  String get language => 'Lugha';

  @override
  String get homeHappySabbath => 'Sabato njema';

  @override
  String get homeSabbathMessage => 'Ujumbe wa Sabato';

  @override
  String homeSabbathBeginsAt(String time) {
    return 'Sabato huanza Ijumaa saa $time';
  }

  @override
  String homeSabbathEndsAt(String time) {
    return 'Sabato inaisha saa $time';
  }

  @override
  String homeDaysToSabbath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'siku hadi Sabato',
    );
    return '$_temp0';
  }

  @override
  String homeHoursToSabbath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'saa hadi Sabato',
    );
    return '$_temp0';
  }

  @override
  String homeMinutesToSabbath(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dakika hadi Sabato',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Yanayokuja';

  @override
  String get homeToday => 'Leo';

  @override
  String get homeNow => 'Sasa';

  @override
  String get homeRead => 'Soma';

  @override
  String homeBulletinPages(int pages) {
    String _temp0 = intl.Intl.pluralLogic(
      pages,
      locale: localeName,
      other: 'kurasa $pages',
      one: 'ukurasa 1',
    );
    return '$_temp0';
  }

  @override
  String get homeGiveSubtitle => 'Zaka na sadaka';

  @override
  String get progWeek => 'Wiki';

  @override
  String get progMonth => 'Mwezi';

  @override
  String get progAllMinistries => 'Idara zote';

  @override
  String get progChooseMinistry => 'Chagua idara';

  @override
  String get progNothingWeek => 'Hakuna ratiba wiki hii.';

  @override
  String get progNothingDay => 'Hakuna ratiba siku hii.';

  @override
  String get progSabbath => 'Sabato';

  @override
  String get progPrevious => 'Iliyotangulia';

  @override
  String get progNext => 'Inayofuata';

  @override
  String homeLastSabbathOn(String date) {
    return 'Sabato iliyopita, $date';
  }

  @override
  String homeThisSabbathOn(String date) {
    return 'Sabato hii, $date';
  }

  @override
  String homeNextSabbathOn(String date) {
    return 'Sabato ijayo, $date';
  }

  @override
  String get homeProgrammeOutWednesday => 'Ratiba itatoka Jumatano';

  @override
  String get homeProgrammeIsOut => 'Ratiba imetoka';
}
