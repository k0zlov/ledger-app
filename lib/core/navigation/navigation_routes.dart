enum RouteDefinition {
  lock('/lock'),
  onboarding('/onboarding'),
  accountsSetup('accounts-setup'),
  settingsSetup('settings-setup'),
  authSetup('auth-setup'),
  dashboard('/dashboard'),
  settings('/settings'),
  transactions('transactions'),
  analytics('analytics'),
  accounts('accounts');

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
