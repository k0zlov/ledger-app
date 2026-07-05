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

  @override
  String get accountsSetupTitle => 'Налаштування рахунків';

  @override
  String get addAccountTitle => 'Додати рахунок';

  @override
  String get editAccountTitle => 'Редагувати рахунок';

  @override
  String get noAccountsYet => 'Поки немає рахунків.';

  @override
  String get accountNamePlaceholder => 'напр., Мій рахунок';

  @override
  String get accountTypeCash => 'Готівка';

  @override
  String get accountTypeBank => 'Банк';

  @override
  String get accountTypeCredit => 'Кредит';

  @override
  String get accountTypeInvestment => 'Інвест';

  @override
  String get cancelButton => 'Скасувати';

  @override
  String get deleteButton => 'Видалити';

  @override
  String get saveButton => 'Зберегти';

  @override
  String get categoriesSetupTitle => 'Налаштування категорий';

  @override
  String get addCategoryTitle => 'Додати категорію';

  @override
  String get editCategoryTitle => 'Редагувати категорію';

  @override
  String get noCategoriesYet => 'Поки немає категорій.';

  @override
  String get categoryNamePlaceholder => 'напр., Продукти, Зарплата';

  @override
  String get categoryTypeExpense => 'Витрати';

  @override
  String get categoryTypeIncome => 'Дохід';

  @override
  String get categoryTypeAny => 'Будь-яка';

  @override
  String get initialBalancesTitle => 'Початкові баланси';

  @override
  String get initialBalancesDescription =>
      'Встановіть поточний баланс для ваших рахунків, щоб облік був точним із самого початку.';

  @override
  String get initialBalanceNote => 'Початковий баланс';

  @override
  String get accountsSetupDescription =>
      'Додайте свої банківські рахунки, кредитні картки та гаманці з готівкою, щоб відстежувати їхній баланс.';

  @override
  String get categoriesSetupDescription =>
      'Створіть категорії для ваших витрат і доходів, щоб впорядкувати та аналізувати свої транзакції.';
}
