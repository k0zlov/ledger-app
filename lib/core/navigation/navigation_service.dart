import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/navigation/navigation_routes.dart';

abstract interface class NavigationService {
  Future<T?> push<T extends Object>(NavigationRoute route);

  void go(NavigationRoute route);

  Future<T?> replace<T extends Object>(NavigationRoute route);

  void pop<T extends Object>([T? result]);
}

class GoRouterNavigationService implements NavigationService {
  const GoRouterNavigationService({required this.router});

  final GoRouter router;

  @override
  void go(NavigationRoute route) {
    router.goNamed(
      route.definition.name,
      pathParameters: route.pathParameters,
      queryParameters: route.queryParameters,
      extra: route.extra,
    );
  }

  @override
  void pop<T extends Object>([T? result]) {
    router.pop(result);
  }

  @override
  Future<T?> push<T extends Object>(NavigationRoute route) {
    return router.pushNamed(
      route.definition.name,
      pathParameters: route.pathParameters,
      queryParameters: route.queryParameters,
      extra: route.extra,
    );
  }

  @override
  Future<T?> replace<T extends Object>(NavigationRoute route) {
    return router.replaceNamed(
      route.definition.name,
      pathParameters: route.pathParameters,
      queryParameters: route.queryParameters,
      extra: route.extra,
    );
  }
}
