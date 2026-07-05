// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get preferences => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get currency => 'Валюта';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get backButton => 'Назад';

  @override
  String get selectCurrency => 'Выберите валюту';

  @override
  String get searchCurrencies => 'Поиск валют';

  @override
  String get welcomeTitle => 'Добро пожаловать';

  @override
  String get welcomeHeading => 'Добро пожаловать в Ledger';

  @override
  String get welcomeDescription =>
      'Самый простой способ отслеживать расходы, управлять счетами и защищать ваши финансовые данные.';

  @override
  String get getStartedButton => 'Начать';

  @override
  String get biometricsTitle => 'Биометрия';

  @override
  String get enableBiometricsHeading => 'Включить биометрию';

  @override
  String get biometricsDescription =>
      'Используйте FaceID или TouchID для быстрого входа без ввода PIN-кода.';

  @override
  String get enableBiometricsButton => 'Включить биометрию';

  @override
  String get skipForNowButton => 'Пропустить пока';

  @override
  String get securitySetupTitle => 'Настройка безопасности';

  @override
  String get secureYourLedgerHeading => 'Защитите свой Ledger';

  @override
  String get setupPinDescription =>
      'Хотите установить PIN-код для защиты ваших финансовых данных?';

  @override
  String get setupPinButton => 'Установить PIN-код';

  @override
  String get skipButton => 'Пропустить';

  @override
  String get accountsSetupTitle => 'Настройка счетов';

  @override
  String get addAccountTitle => 'Добавить счет';

  @override
  String get editAccountTitle => 'Редактировать счет';

  @override
  String get noAccountsYet => 'Пока нет счетов.';

  @override
  String get accountNamePlaceholder => 'напр., Мой счет';

  @override
  String get accountTypeCash => 'Наличные';

  @override
  String get accountTypeBank => 'Банк';

  @override
  String get accountTypeCredit => 'Кредит';

  @override
  String get accountTypeInvestment => 'Инвест';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get deleteButton => 'Удалить';

  @override
  String get saveButton => 'Сохранить';

  @override
  String get categoriesSetupTitle => 'Настройка категорий';

  @override
  String get addCategoryTitle => 'Добавить категорию';

  @override
  String get editCategoryTitle => 'Редактировать категорию';

  @override
  String get noCategoriesYet => 'Пока нет категорий.';

  @override
  String get categoryNamePlaceholder => 'напр., Продукты, Зарплата';

  @override
  String get categoryTypeExpense => 'Расход';

  @override
  String get categoryTypeIncome => 'Доход';

  @override
  String get categoryTypeAny => 'Любая';

  @override
  String get initialBalancesTitle => 'Начальные балансы';

  @override
  String get initialBalancesDescription =>
      'Установите текущий баланс для ваших счетов, чтобы учет был точным с самого начала.';

  @override
  String get initialBalanceNote => 'Начальный баланс';

  @override
  String get accountsSetupDescription =>
      'Добавьте свои банковские счета, кредитные карты и кошельки с наличными, чтобы отслеживать их баланс.';

  @override
  String get categoriesSetupDescription =>
      'Создайте категории для ваших расходов и доходов, чтобы упорядочить и анализировать свои транзакции.';
}
