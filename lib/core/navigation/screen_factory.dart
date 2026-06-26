import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/application.dart';

abstract class ScreenFactory {
  static Widget renderApplication({required GoRouter router}) {
    return Application(router: router);
  }

  static Widget renderOnboardingWrapper(Widget child) {
    return const Placeholder();
  }

  static Widget renderOnboardingWelcomingScreen() {
    return const Placeholder();
  }

  static Widget renderAccountsSetupScreen() {
    return const Placeholder();
  }

  static Widget renderSettingsSetupScreen() {
    return const Placeholder();
  }

  static Widget renderAuthSetupScreen() {
    return const Placeholder();
  }

  static Widget renderDashboardScreen() {
    return const Placeholder();
  }

  static Widget renderSettingsScreen() {
    return const Placeholder();
  }

  static Widget renderNavigationWrapper(StatefulNavigationShell navigationShell) {
    return const Placeholder();
  }

  static Widget renderAccountsScreen() {
    return const Placeholder();
  }

  static Widget renderTransactionsScreen() {
    return const Placeholder();
  }

  static Widget renderAnalyticsScreen() {
    return const Placeholder();
  }
}
