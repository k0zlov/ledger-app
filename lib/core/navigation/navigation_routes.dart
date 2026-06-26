enum RouteName {
  onboarding,
}

sealed class NavigationRoute {
  RouteName get name;

  Map<String, dynamic> get parameters => {};
}

class OnboardingRoute extends NavigationRoute {
  @override
  RouteName get name => RouteName.onboarding;
}
