// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get preferences => 'Налаштування';

  @override
  String get language => 'Мова';

  @override
  String get currency => 'Валюта';

  @override
  String get continueButton => 'Продовжити';

  @override
  String get backButton => 'Назад';

  @override
  String get selectCurrency => 'Виберіть валюту';

  @override
  String get searchCurrencies => 'Пошук валют';

  @override
  String get welcomeTitle => 'Вітаємо';

  @override
  String get welcomeHeading => 'Вітаємо в Ledger';

  @override
  String get welcomeDescription =>
      'Найпростіший спосіб відстежувати витрати, керувати рахунками та захищати ваші фінансові дані.';

  @override
  String get getStartedButton => 'Почати';

  @override
  String get biometricsTitle => 'Біометрія';

  @override
  String get enableBiometricsHeading => 'Увімкнути біометрію';

  @override
  String get biometricsDescription =>
      'Використовуйте FaceID або TouchID для швидшого входу без введення PIN-коду.';

  @override
  String get enableBiometricsButton => 'Увімкнути біометрію';

  @override
  String get skipForNowButton => 'Пропустити поки';

  @override
  String get securitySetupTitle => 'Налаштування безпеки';

  @override
  String get secureYourLedgerHeading => 'Захистіть свій Ledger';

  @override
  String get setupPinDescription =>
      'Бажаєте встановити PIN-код для захисту ваших фінансових даних?';

  @override
  String get setupPinButton => 'Встановити PIN-код';

  @override
  String get skipButton => 'Пропустити';
}
