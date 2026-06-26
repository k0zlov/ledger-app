enum RouteDefinition {
  onboarding('/onboarding');

  const RouteDefinition(this.path);

  final String path;
}

sealed class NavigationRoute {
  RouteDefinition get definition;

  Map<String, String> get pathParameters => {};

  Map<String, dynamic> get queryParameters => {};

  Map<String, dynamic> get extra => {};
}

class OnboardingRoute extends NavigationRoute {
  @override
  RouteDefinition get definition => RouteDefinition.onboarding;
}
