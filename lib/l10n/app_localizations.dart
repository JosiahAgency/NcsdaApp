import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Nairobi Central'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProgram.
  ///
  /// In en, this message translates to:
  /// **'Programme'**
  String get navProgram;

  /// No description provided for @navGive.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get navGive;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @sabbathBegins.
  ///
  /// In en, this message translates to:
  /// **'Sabbath begins'**
  String get sabbathBegins;

  /// No description provided for @orderOfService.
  ///
  /// In en, this message translates to:
  /// **'Order of service'**
  String get orderOfService;

  /// No description provided for @weeklyBulletin.
  ///
  /// In en, this message translates to:
  /// **'Weekly bulletin'**
  String get weeklyBulletin;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @phoneHelp.
  ///
  /// In en, this message translates to:
  /// **'The number that will receive the payment prompt'**
  String get phoneHelp;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please check the phone number'**
  String get phoneInvalid;

  /// No description provided for @payButton.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payButton(String amount);

  /// No description provided for @webCheckoutButton.
  ///
  /// In en, this message translates to:
  /// **'Continue to secure checkout'**
  String get webCheckoutButton;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @payStep.
  ///
  /// In en, this message translates to:
  /// **'Payment {current} of {total}'**
  String payStep(int current, int total);

  /// No description provided for @payInstruction.
  ///
  /// In en, this message translates to:
  /// **'Check your phone and enter your PIN.'**
  String get payInstruction;

  /// No description provided for @statusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get statusSkipped;

  /// No description provided for @payFailed.
  ///
  /// In en, this message translates to:
  /// **'That payment did not go through.'**
  String get payFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @skipThis.
  ///
  /// In en, this message translates to:
  /// **'Skip this one'**
  String get skipThis;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thankYou;

  /// No description provided for @thankYouBody.
  ///
  /// In en, this message translates to:
  /// **'Your giving has been received. A confirmation SMS will arrive on your phone.'**
  String get thankYouBody;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load. Please try again.'**
  String get loadFailed;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @homeComingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get homeComingUp;

  /// No description provided for @homeToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeToday;

  /// No description provided for @homeGiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'M-Pesa, Airtel Money and bank'**
  String get homeGiveSubtitle;

  /// No description provided for @homeLastSabbathOn.
  ///
  /// In en, this message translates to:
  /// **'Last Sabbath, {date}'**
  String homeLastSabbathOn(String date);

  /// No description provided for @homeThisSabbathOn.
  ///
  /// In en, this message translates to:
  /// **'This Sabbath, {date}'**
  String homeThisSabbathOn(String date);

  /// No description provided for @homeNextSabbathOn.
  ///
  /// In en, this message translates to:
  /// **'Next Sabbath, {date}'**
  String homeNextSabbathOn(String date);

  /// No description provided for @homeProgrammeOutWednesday.
  ///
  /// In en, this message translates to:
  /// **'Programme out Wednesday'**
  String get homeProgrammeOutWednesday;

  /// No description provided for @homeProgrammeIsOut.
  ///
  /// In en, this message translates to:
  /// **'Programme is out'**
  String get homeProgrammeIsOut;

  /// No description provided for @progWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get progWeek;

  /// No description provided for @progMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get progMonth;

  /// No description provided for @progAllMinistries.
  ///
  /// In en, this message translates to:
  /// **'All ministries'**
  String get progAllMinistries;

  /// No description provided for @progChooseMinistry.
  ///
  /// In en, this message translates to:
  /// **'Choose a ministry'**
  String get progChooseMinistry;

  /// No description provided for @progNothingWeek.
  ///
  /// In en, this message translates to:
  /// **'Nothing is scheduled this week.'**
  String get progNothingWeek;

  /// No description provided for @progNothingDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing is scheduled on this day.'**
  String get progNothingDay;

  /// No description provided for @progSabbath.
  ///
  /// In en, this message translates to:
  /// **'Sabbath'**
  String get progSabbath;

  /// No description provided for @progPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get progPrevious;

  /// No description provided for @progNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get progNext;

  /// No description provided for @giveTitle.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get giveTitle;

  /// No description provided for @giveHowIntro.
  ///
  /// In en, this message translates to:
  /// **'How would you like to give?'**
  String get giveHowIntro;

  /// No description provided for @giveTagInApp.
  ///
  /// In en, this message translates to:
  /// **'Pay in this app'**
  String get giveTagInApp;

  /// No description provided for @giveTagCheckout.
  ///
  /// In en, this message translates to:
  /// **'Opens secure checkout'**
  String get giveTagCheckout;

  /// No description provided for @giveTagDetails.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get giveTagDetails;

  /// No description provided for @givePaybillValue.
  ///
  /// In en, this message translates to:
  /// **'Paybill {number}'**
  String givePaybillValue(String number);

  /// No description provided for @giveAccountValue.
  ///
  /// In en, this message translates to:
  /// **'Account {number}'**
  String giveAccountValue(String number);

  /// No description provided for @giveReceiptNote.
  ///
  /// In en, this message translates to:
  /// **'Your receipt is the SMS you get from M-Pesa or Airtel. This app does not keep a record of your giving.'**
  String get giveReceiptNote;

  /// No description provided for @giveBy.
  ///
  /// In en, this message translates to:
  /// **'Give by {method}'**
  String giveBy(String method);

  /// No description provided for @givePaybill.
  ///
  /// In en, this message translates to:
  /// **'Paybill number'**
  String get givePaybill;

  /// No description provided for @giveAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account: {account}'**
  String giveAccountLabel(String account);

  /// No description provided for @giveAmountsIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount next to each reason you would like to give for.'**
  String get giveAmountsIntro;

  /// No description provided for @giveCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Check and pay'**
  String get giveCheckTitle;

  /// No description provided for @giveSequentialNote.
  ///
  /// In en, this message translates to:
  /// **'You will get one prompt for each reason, one after the other. Enter your PIN each time.'**
  String get giveSequentialNote;

  /// No description provided for @giveBankTitle.
  ///
  /// In en, this message translates to:
  /// **'Give by bank'**
  String get giveBankTitle;

  /// No description provided for @giveBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get giveBankName;

  /// No description provided for @giveBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get giveBankAccount;

  /// No description provided for @giveBankReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Reason for giving'**
  String get giveBankReasonTitle;

  /// No description provided for @giveBankReasonHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose a reason and write it as your payment reference.'**
  String get giveBankReasonHelp;

  /// No description provided for @giveBankReference.
  ///
  /// In en, this message translates to:
  /// **'Your payment reference'**
  String get giveBankReference;

  /// No description provided for @giveBankNote.
  ///
  /// In en, this message translates to:
  /// **'Bank giving is done from your bank, not inside this app.'**
  String get giveBankNote;

  /// No description provided for @giveCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get giveCopy;

  /// No description provided for @giveCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get giveCopied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
