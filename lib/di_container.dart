import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/navigation/app_status_service.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/navigation/router.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:ledger_app/features/auth/data/providers/auth_provider.dart';
import 'package:ledger_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ledger_app/features/auth/domain/use_cases/check_biometrics_availability_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/enable_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/setup_pin_code_use_case.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:local_auth/local_auth.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerDependencies() async {
  _database();
  _secureStorage();
  _navigation();
  _localAuth();
  _providers();
  _repositories();
  _useCases();
  _cubits();
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

void _localAuth() {
  getIt.registerLazySingleton<LocalAuthentication>(LocalAuthentication.new);
}

void _providers() {
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProviderImpl(localAuth: getIt(), secureStorage: getIt()),
  );
}

void _repositories() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authProvider: getIt()));
}

void _useCases() {
  getIt
    ..registerLazySingleton(() => SetupPinCodeUseCase(repository: getIt()))
    ..registerLazySingleton(() => CheckBiometricsAvailabilityUseCase(repository: getIt()))
    ..registerLazySingleton(() => EnableBiometricsUseCase(repository: getIt()));
}

void _cubits() {
  getIt.registerLazySingleton(
    () => AuthCubit(
      setupPinCode: getIt(),
      checkBiometricsAvailability: getIt(),
      enableBiometrics: getIt(),
    ),
  );
}
