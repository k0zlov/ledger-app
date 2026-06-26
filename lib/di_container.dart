import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/navigation/app_status_service.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/navigation/router.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerDependencies() async {
  _database();
  _secureStorage();
  _navigation();
  await getIt.allReady(timeout: const Duration(seconds: 5));
}

void _database() {
  getIt.registerLazySingleton<Database>(Database.new);
}

void _secureStorage() {
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorageImpl(
      storage: const FlutterSecureStorage(iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock)),
    ),
  );
}

void _navigation() {
  getIt
    ..registerSingletonAsync<AppStatusService>(() async {
      final AppStatusService service = AppStatusServiceImpl(secureStorage: getIt());

      await service.initialize();

      return service;
    })
    ..registerLazySingleton<GoRouter>(() => createRouter(getIt()))
    ..registerLazySingleton<NavigationService>(() => GoRouterNavigationService(router: getIt()));
}
