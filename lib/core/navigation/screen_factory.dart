import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/application.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/core/view/screens/navigation_wrapper.dart';
import 'package:ledger_app/di_container.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/accounts/view/screens/accounts_screen.dart';
import 'package:ledger_app/features/accounts/view/screens/accounts_setup_screen.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/auth/view/screens/auth_lock_screen.dart';
import 'package:ledger_app/features/auth/view/screens/auth_setup_screen.dart';
import 'package:ledger_app/features/categories/view/cubit/categories_cubit.dart';
import 'package:ledger_app/features/categories/view/screens/categories_screen.dart';
import 'package:ledger_app/features/categories/view/screens/categories_setup_screen.dart';
import 'package:ledger_app/features/dashboard/view/cubit/dashboard_cubit.dart';
import 'package:ledger_app/features/dashboard/view/screens/dashboard_screen.dart';
import 'package:ledger_app/features/onboarding/view/cubit/onboarding_cubit.dart';
import 'package:ledger_app/features/onboarding/view/screens/onboarding_welcome_screen.dart';
import 'package:ledger_app/features/onboarding/view/screens/onboarding_wrapper_screen.dart';
import 'package:ledger_app/features/settings/view/screens/app_info_screen.dart';
import 'package:ledger_app/features/settings/view/screens/currency_selection_screen.dart';
import 'package:ledger_app/features/settings/view/screens/help_and_support_screen.dart';
import 'package:ledger_app/features/settings/view/screens/language_settings_screen.dart';
import 'package:ledger_app/features/settings/view/screens/settings_screen.dart';
import 'package:ledger_app/features/settings/view/screens/settings_setup_screen.dart';
import 'package:ledger_app/features/settings/view/screens/theme_settings_screen.dart';
import 'package:ledger_app/features/transactions/view/cubit/transactions_cubit.dart';
import 'package:ledger_app/features/transactions/view/screens/transactions_setup_screen.dart';

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

  static Widget renderCategoriesSetupScreen() {
    return BlocProvider(
      create: (context) {
        final CategoriesCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: _renderOnboardingWrapper(
        builder: (onComplete) => CategoriesSetupScreen(onSetupComplete: onComplete),
      ),
    );
  }

  static Widget renderTransactionsSetupScreen() {
    return BlocProvider(
      create: (context) {
        final TransactionsCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: _renderOnboardingWrapper(
        builder: (onComplete) => TransactionsSetupScreen(onSetupComplete: onComplete),
      ),
    );
  }

  static Widget renderAuthLockScreen() {
    return BlocProvider(
      lazy: false,
      create: (context) {
        final AuthCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: const AuthLockScreen(),
    );
  }

  static Widget renderDashboardScreen() {
    return BlocProvider(
      lazy: false,
      create: (context) {
        final DashboardCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: const DashboardScreen(),
    );
  }

  static Widget renderSettingsScreen() {
    return const SettingsScreen();
  }

  static Widget renderCurrencySelectionScreen(String? selectedCurrency) {
    return CurrencySelectionScreen(selectedCurrency: selectedCurrency);
  }

  static Widget renderThemeSelectionScreen() {
    return const ThemeSettingsScreen();
  }

  static Widget renderLanguageSelectionScreen() {
    return const LanguageSettingsScreen();
  }

  static Widget renderNavigationWrapper(
    StatefulNavigationShell navigationShell,
  ) {
    return NavigationWrapper(navigationShell: navigationShell);
  }

  static Widget renderAppInfoScreen() {
    return const AppInfoScreen(
      appName: 'Ledger App',
      version: '1.0.0',
      buildNumber: '1',
      developer: 'k0zlov',
    );
  }

  static Widget renderHelpAndSupportScreen() {
    return const HelpAndSupportScreen(
      githubNickname: 'k0zlov',
      githubUrl: 'https://github.com/k0zlov',
      avatarUrl: 'https://avatars.githubusercontent.com/k0zlov?v=4',
    );
  }

  static Widget renderAnalyticsScreen() {
    return const Placeholder();
  }

  static Widget renderAccountsScreen() {
    return BlocProvider(
      lazy: false,
      create: (context) {
        final AccountsCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: const AccountsScreen(),
    );
  }

  static Widget renderCategoriesScreen() {
    return BlocProvider(
      create: (context) {
        final CategoriesCubit cubit = getIt();
        unawaited(cubit.initialize());
        return cubit;
      },
      child: const CategoriesScreen(),
    );
  }
}
