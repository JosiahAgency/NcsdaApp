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
  String get sabbathBegins => 'Sabato huanza';

  @override
  String get orderOfService => 'Ratiba ya ibada';

  @override
  String get weeklyBulletin => 'Matangazo ya wiki';

  @override
  String get continueLabel => 'Endelea';

  @override
  String get totalLabel => 'Jumla';

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
  String get homeComingUp => 'Yanayokuja';

  @override
  String get homeToday => 'Leo';

  @override
  String get homeGiveSubtitle => 'M-Pesa, Airtel Money na benki';

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
  String get giveTitle => 'Toa';

  @override
  String get giveHowIntro => 'Ungependa kutoa kwa njia gani?';

  @override
  String get giveTagInApp => 'Lipa ndani ya programu hii';

  @override
  String get giveTagCheckout => 'Hufungua malipo salama';

  @override
  String get giveTagDetails => 'Maelezo ya akaunti';

  @override
  String givePaybillValue(String number) {
    return 'Paybill $number';
  }

  @override
  String giveAccountValue(String number) {
    return 'Akaunti $number';
  }

  @override
  String get giveReceiptNote =>
      'Risiti yako ni ujumbe wa SMS kutoka M-Pesa au Airtel. Programu hii haihifadhi rekodi ya utoaji wako.';

  @override
  String giveBy(String method) {
    return 'Toa kwa $method';
  }

  @override
  String get givePaybill => 'Namba ya Paybill';

  @override
  String giveAccountLabel(String account) {
    return 'Akaunti: $account';
  }

  @override
  String get giveAmountsIntro =>
      'Andika kiasi karibu na kila sababu unayotaka kutoa.';

  @override
  String get giveCheckTitle => 'Hakiki na ulipe';

  @override
  String get giveSequentialNote =>
      'Utapokea ombi moja kwa kila sababu, moja baada ya jingine. Weka PIN yako kila mara.';

  @override
  String get giveBankTitle => 'Toa kwa benki';

  @override
  String get giveBankName => 'Benki';

  @override
  String get giveBankAccount => 'Namba ya akaunti';

  @override
  String get giveBankReasonTitle => 'Sababu ya kutoa';

  @override
  String get giveBankReasonHelp =>
      'Chagua sababu na uiandike kama kumbukumbu ya malipo.';

  @override
  String get giveBankReference => 'Kumbukumbu yako ya malipo';

  @override
  String get giveBankNote =>
      'Utoaji kwa benki hufanywa kupitia benki yako, si ndani ya programu hii.';

  @override
  String get giveCopy => 'Nakili';

  @override
  String get giveCopied => 'Imenakiliwa';
}
