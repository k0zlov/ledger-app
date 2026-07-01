import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/application.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';

abstract class ScreenFactory {
  static Widget renderApplication({
    required GoRouter router,
    required NavigationService navigationService,
    required AuthCubit authCubit,
  }) {
    return NavigationServiceProvider(
      navigationService: navigationService,
      child: BlocProvider.value(
        value: authCubit,
        child: Application(router: router),
      ),
    );
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

  static Widget renderNavigationWrapper(
    StatefulNavigationShell navigationShell,
  ) {
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
