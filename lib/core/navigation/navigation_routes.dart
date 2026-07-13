enum RouteDefinition {
  authLock('/lock'),
  onboarding('/onboarding'),
  accountsSetup('accounts-setup'),
  settingsSetup('settings-setup'),
  categoriesSetup('categories-setup'),
  transactionsSetup('transactions-setup'),
  authSetup('auth-setup'),
  dashboard('/dashboard'),
  settings('/settings'),
  transactions('transactions'),
  analytics('/analytics'),
  accounts('accounts'),
  categories('categories'),
  currencySelection('currency-selection'),
  themeSelection('theme-selection'),
  languageSelection('language-selection'),
  appInfo('app-info'),
  authSettings('auth-settings'),
  helpAndSupport('help-and-support');

  const RouteDefinition(this.path);

  final String path;
}

sealed class NavigationRoute {
  const NavigationRoute();

  RouteDefinition get definition;

  Map<String, String> get pathParameters => {};

  Map<String, dynamic> get queryParameters => {};

  Map<String, dynamic> get extra => {};
}

class AccountsRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.accounts;
}

class CategoriesRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.categories;
}

class AppInfoRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.appInfo;
}

class HelpAndSupportRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.helpAndSupport;
}

class OnboardingRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.onboarding;
}

class AuthSetupRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.authSetup;
}

class SettingsSetupRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.settingsSetup;
}

class AccountsSetupRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.accountsSetup;
}

class CategoriesSetupRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.categoriesSetup;
}

class TransactionsSetupRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.transactionsSetup;
}

class SettingsScreenRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.settings;
}

class CurrencySelectionRoute extends NavigationRoute {
  const CurrencySelectionRoute({this.selectedCurrency});

  final String? selectedCurrency;

  @override
  RouteDefinition get definition => RouteDefinition.currencySelection;

  @override
  Map<String, dynamic> get extra => {
    if (selectedCurrency != null) 'selectedCurrency': selectedCurrency,
  };
}

class ThemeSelectionRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.themeSelection;
}

class LanguageSelectionRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.languageSelection;
}

class AuthSettingsRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.authSettings;
}
