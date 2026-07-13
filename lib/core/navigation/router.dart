import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/contracts/auth_state_contract.dart';
import 'package:ledger_app/core/contracts/onboarding_status_contract.dart';
import 'package:ledger_app/core/navigation/navigation_refresh_stream.dart';
import 'package:ledger_app/core/navigation/navigation_routes.dart';
import 'package:ledger_app/core/navigation/screen_factory.dart';
import 'package:ledger_app/core/view/widgets/animated_branch_container.dart';

GoRouter createRouter({
  required AuthStatusContract authStatus,
  required OnboardingStatusContract onboardingStatus,
}) {
  return GoRouter(
    initialLocation: RouteDefinition.dashboard.path,
    refreshListenable: Listenable.merge([
      NavigationRefreshStream(stream: authStatus.lockStateStream),
      NavigationRefreshStream(stream: onboardingStatus.completeStream),
    ]),
    redirect: (context, state) {
      final String currentLocation = state.matchedLocation;

      final bool isLocked = authStatus.isLocked;
      final bool isOnboardingComplete = onboardingStatus.isOnboardingComplete;

      final String onboardingPath = RouteDefinition.onboarding.path;
      final bool isOnOnboarding = currentLocation.startsWith(onboardingPath);

      final String lockPath = RouteDefinition.authLock.path;
      final bool isOnLockScreen = currentLocation == lockPath;

      if (!isOnboardingComplete) {
        return isOnOnboarding ? null : onboardingPath;
      }

      if (isLocked) {
        return isOnLockScreen ? null : lockPath;
      }

      if (isOnOnboarding || isOnLockScreen) {
        return RouteDefinition.dashboard.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteDefinition.authLock.name,
        path: RouteDefinition.authLock.path,
        builder: (context, state) => ScreenFactory.renderAuthLockScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => ScreenFactory.renderOnboardingShell(child),
        routes: [
          GoRoute(
            name: RouteDefinition.onboarding.name,
            path: RouteDefinition.onboarding.path,
            builder: (context, state) => ScreenFactory.renderOnboardingWelcomingScreen(),
            routes: [
              GoRoute(
                name: RouteDefinition.settingsSetup.name,
                path: RouteDefinition.settingsSetup.path,
                builder: (context, state) => ScreenFactory.renderSettingsSetupScreen(),
              ),
              GoRoute(
                name: RouteDefinition.authSetup.name,
                path: RouteDefinition.authSetup.path,
                builder: (context, state) => ScreenFactory.renderAuthSetupScreen(),
              ),
              GoRoute(
                name: RouteDefinition.accountsSetup.name,
                path: RouteDefinition.accountsSetup.path,
                builder: (context, state) => ScreenFactory.renderAccountsSetupScreen(),
              ),
              GoRoute(
                name: RouteDefinition.categoriesSetup.name,
                path: RouteDefinition.categoriesSetup.path,
                builder: (context, state) => ScreenFactory.renderCategoriesSetupScreen(),
              ),
              GoRoute(
                name: RouteDefinition.transactionsSetup.name,
                path: RouteDefinition.transactionsSetup.path,
                builder: (context, state) => ScreenFactory.renderTransactionsSetupScreen(),
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute(
        builder: (context, state, navigationShell) => ScreenFactory.renderNavigationWrapper(navigationShell),
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteDefinition.settings.name,
                path: RouteDefinition.settings.path,
                builder: (context, state) => ScreenFactory.renderSettingsScreen(),
                routes: [
                  GoRoute(
                    name: RouteDefinition.currencySelection.name,
                    path: RouteDefinition.currencySelection.path,
                    builder: (context, state) {
                      final selectedCurrency = state.extra is Map<String, dynamic>
                          ? (state.extra! as Map<String, dynamic>)['selectedCurrency'] as String?
                          : null;
                      return ScreenFactory.renderCurrencySelectionScreen(selectedCurrency);
                    },
                  ),
                  GoRoute(
                    name: RouteDefinition.themeSelection.name,
                    path: RouteDefinition.themeSelection.path,
                    builder: (context, state) => ScreenFactory.renderThemeSelectionScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.languageSelection.name,
                    path: RouteDefinition.languageSelection.path,
                    builder: (context, state) => ScreenFactory.renderLanguageSelectionScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.appInfo.name,
                    path: RouteDefinition.appInfo.path,
                    builder: (context, state) => ScreenFactory.renderAppInfoScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.helpAndSupport.name,
                    path: RouteDefinition.helpAndSupport.path,
                    builder: (context, state) => ScreenFactory.renderHelpAndSupportScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.accounts.name,
                    path: RouteDefinition.accounts.path,
                    builder: (context, state) => ScreenFactory.renderAccountsScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.categories.name,
                    path: RouteDefinition.categories.path,
                    builder: (context, state) => ScreenFactory.renderCategoriesScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.authSettings.name,
                    path: RouteDefinition.authSettings.path,
                    builder: (context, state) => ScreenFactory.renderAuthSettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteDefinition.dashboard.name,
                path: RouteDefinition.dashboard.path,
                builder: (context, state) => ScreenFactory.renderDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteDefinition.analytics.name,
                path: RouteDefinition.analytics.path,
                builder: (context, state) => ScreenFactory.renderAnalyticsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
