import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/application.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/di_container.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/accounts/view/screens/accounts_setup_screen.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/auth/view/screens/auth_setup_screen.dart';
import 'package:ledger_app/features/onboarding/view/cubit/onboarding_cubit.dart';
import 'package:ledger_app/features/onboarding/view/screens/onboarding_welcome_screen.dart';
import 'package:ledger_app/features/onboarding/view/screens/onboarding_wrapper_screen.dart';
import 'package:ledger_app/features/settings/view/cubit/settings_cubit.dart';
import 'package:ledger_app/features/settings/view/screens/settings_setup_screen.dart';

abstract class ScreenFactory {
  static Widget renderApplication() {
    return NavigationServiceProvider(
      navigationService: getIt(),
      child: BlocProvider(
        lazy: false,
        create: (context) {
          final SettingsCubit cubit = getIt<SettingsCubit>();
          unawaited(cubit.initialize());
          return cubit;
        },
        child: Application(router: getIt()),
      ),
    );
  }

  static Widget renderOnboardingShell(Widget child) {
    return BlocProvider<OnboardingCubit>(
      lazy: false,
      create: (context) {
        final OnboardingCubit cubit = getIt<OnboardingCubit>();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: child,
    );
  }

  static Widget _renderOnboardingWrapper({required OnboardingChildBuilder builder}) {
    return OnboardingWrapperScreen(builder: builder);
  }

  static Widget renderOnboardingWelcomingScreen() {
    return _renderOnboardingWrapper(
      builder: (onComplete) => OnboardingWelcomingScreen(onGetStarted: onComplete),
    );
  }

  static Widget renderSettingsSetupScreen() {
    return _renderOnboardingWrapper(
      builder: (onComplete) => SettingsSetupScreen(onSetupComplete: onComplete),
    );
  }

  static Widget renderAuthSetupScreen() {
    return BlocProvider<AuthCubit>(
      lazy: false,
      create: (context) {
        final AuthCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: _renderOnboardingWrapper(
        builder: (onComplete) => AuthSetupScreen(onSetupComplete: onComplete),
      ),
    );
  }

  static Widget renderAccountsSetupScreen() {
    return BlocProvider(
      lazy: false,
      create: (context) {
        final AccountsCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: _renderOnboardingWrapper(
        builder: (onComplete) => AccountsSetupScreen(onSetupComplete: onComplete),
      ),
    );
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
