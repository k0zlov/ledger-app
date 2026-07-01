import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/navigation/app_status_service.dart';
import 'package:ledger_app/core/navigation/navigation_routes.dart';
import 'package:ledger_app/core/navigation/screen_factory.dart';

GoRouter createRouter(AppStatusService appStatusService) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: appStatusService.statusListenable,
    redirect: (context, state) {
      final String currentLocation = state.matchedLocation;
      final AppStatus currentAppStatus = appStatusService.currentStatus;

      final String onboardingPath = RouteDefinition.onboarding.path;
      final bool isOnOnboarding = currentLocation.startsWith(onboardingPath);

      if (currentAppStatus == .onboarding && !isOnOnboarding) {
        return RouteDefinition.onboarding.path;
      }

      if (currentAppStatus == .ready && isOnOnboarding) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        name: RouteDefinition.onboarding.name,
        path: RouteDefinition.onboarding.path,
        builder: (context, state) => ScreenFactory.renderOnboardingWelcomingScreen(),
        routes: [
          GoRoute(
            name: RouteDefinition.authSetup.name,
            path: RouteDefinition.authSetup.path,
            builder: (context, state) => ScreenFactory.renderAuthSetupScreen(),
          ),
          GoRoute(
            name: RouteDefinition.settingsSetup.name,
            path: RouteDefinition.settingsSetup.path,
            builder: (context, state) => ScreenFactory.renderSettingsSetupScreen(),
          ),
          GoRoute(
            name: RouteDefinition.accountsSetup.name,
            path: RouteDefinition.accountsSetup.path,
            builder: (context, state) => ScreenFactory.renderAccountsSetupScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ScreenFactory.renderNavigationWrapper(navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteDefinition.dashboard.name,
                path: RouteDefinition.dashboard.path,
                builder: (context, state) => ScreenFactory.renderDashboardScreen(),
                routes: [
                  GoRoute(
                    name: RouteDefinition.accounts.name,
                    path: RouteDefinition.accounts.path,
                    builder: (context, state) => ScreenFactory.renderAccountsScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.transactions.name,
                    path: RouteDefinition.transactions.path,
                    builder: (context, state) => ScreenFactory.renderTransactionsScreen(),
                  ),
                  GoRoute(
                    name: RouteDefinition.analytics.name,
                    path: RouteDefinition.analytics.path,
                    builder: (context, state) => ScreenFactory.renderAnalyticsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: RouteDefinition.settings.name,
                path: RouteDefinition.settings.path,
                builder: (context, state) => ScreenFactory.renderSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
