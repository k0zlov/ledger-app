// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get continueButton => 'Continue';

  @override
  String get backButton => 'Back';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get searchCurrencies => 'Search currencies';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeHeading => 'Welcome to Ledger';

  @override
  String get welcomeDescription =>
      'The simplest way to track your expenses, manage your accounts, and secure your financial data.';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get biometricsTitle => 'Biometrics';

  @override
  String get enableBiometricsHeading => 'Enable Biometrics';

  @override
  String get biometricsDescription =>
      'Use FaceID or TouchID to log in faster without typing your PIN.';

  @override
  String get enableBiometricsButton => 'Enable Biometrics';

  @override
  String get skipForNowButton => 'Skip for now';

  @override
  String get securitySetupTitle => 'Security Setup';

  @override
  String get secureYourLedgerHeading => 'Secure your Ledger';

  @override
  String get setupPinDescription =>
      'Would you like to set up a PIN code to protect your financial data?';

  @override
  String get setupPinButton => 'Set Up PIN Code';

  @override
  String get skipButton => 'Skip';

  @override
  String get accountsSetupTitle => 'Accounts Setup';

  @override
  String get addAccountTitle => 'Add Account';

  @override
  String get editAccountTitle => 'Edit Account';

  @override
  String get noAccountsYet => 'No accounts yet.';

  @override
  String get accountNamePlaceholder => 'e.g., Chase Checking';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeCredit => 'Credit';

  @override
  String get accountTypeInvestment => 'Invest';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get saveButton => 'Save';
}
