import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/contracts/auth_state_contract.dart';
import 'package:ledger_app/core/contracts/onboarding_status_contract.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/navigation/router.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:ledger_app/features/auth/data/providers/auth_biometric_provider.dart';
import 'package:ledger_app/features/auth/data/providers/auth_storage_provider.dart';
import 'package:ledger_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ledger_app/features/auth/domain/use_cases/check_biometric_availability_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/get_security_settings_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/set_pin_code_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/toggle_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/onboarding/data/providers/onboarding_storage_provider.dart';
import 'package:ledger_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:ledger_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:ledger_app/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:ledger_app/features/onboarding/domain/use_cases/get_onboarding_progress_use_case.dart';
import 'package:ledger_app/features/onboarding/domain/use_cases/set_onboarding_progress_use_case.dart';
import 'package:ledger_app/features/onboarding/view/cubit/onboarding_cubit.dart';
import 'package:ledger_app/features/settings/data/providers/settings_storage_provider.dart';
import 'package:ledger_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ledger_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:ledger_app/features/settings/domain/use_cases/get_app_settings_use_case.dart';
import 'package:ledger_app/features/settings/domain/use_cases/save_app_settings_use_case.dart';
import 'package:ledger_app/features/settings/view/cubit/settings_cubit.dart';
import 'package:local_auth/local_auth.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerDependencies() async {
  _database();
  _secureStorage();
  _localAuth();
  _providers();
  _repositories();
  _useCases();
  _cubits();
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
    ..registerLazySingleton<GoRouter>(
      () => createRouter(
        authStatus: getIt(),
        onboardingStatus: getIt(),
      ),
    )
    ..registerLazySingleton<NavigationService>(() => GoRouterNavigationService(router: getIt()));
}

void _localAuth() {
  getIt.registerLazySingleton<LocalAuthentication>(LocalAuthentication.new);
}

void _providers() {
  getIt
    ..registerLazySingleton<AuthStorageProvider>(
      () => AuthStorageProviderImpl(secureStorage: getIt()),
    )
    ..registerLazySingleton<AuthBiometricProvider>(
      () => AuthBiometricProviderImpl(localAuth: getIt()),
    )
    ..registerLazySingleton<SettingsStorageProvider>(
      () => SettingsStorageProviderImpl(secureStorage: getIt()),
    )
    ..registerLazySingleton<OnboardingStorageProvider>(
      () => OnboardingStorageProviderImpl(secureStorage: getIt()),
    );
}

void _repositories() {
  getIt
    ..registerSingletonAsync<AuthRepositoryImpl>(() async {
      final repository = AuthRepositoryImpl(
        storageProvider: getIt(),
        biometricProvider: getIt(),
      );

      await repository.initialize();
      return repository;
    })
    ..registerLazySingleton<AuthRepository>(getIt.call<AuthRepositoryImpl>)
    ..registerLazySingleton<AuthStatusContract>(getIt.call<AuthRepositoryImpl>)
    ..registerSingletonAsync<OnboardingRepositoryImpl>(() async {
      final repository = OnboardingRepositoryImpl(storageProvider: getIt());

      await repository.initialize();
      return repository;
    })
    ..registerLazySingleton<OnboardingRepository>(getIt.call<OnboardingRepositoryImpl>)
    ..registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(storageProvider: getIt()))
    ..registerLazySingleton<OnboardingStatusContract>(getIt.call<OnboardingRepositoryImpl>);
}

void _useCases() {
  getIt
    ..registerLazySingleton(() => SetPinCodeUseCase(repository: getIt()))
    ..registerLazySingleton(() => GetSecuritySettingsUseCase(repository: getIt()))
    ..registerLazySingleton(() => CheckBiometricAvailabilityUseCase(repository: getIt()))
    ..registerLazySingleton(() => ToggleBiometricsUseCase(repository: getIt()))
    ..registerLazySingleton(() => SetOnboardingProgressUseCase(repository: getIt()))
    ..registerLazySingleton(() => GetOnboardingProgressUseCase(repository: getIt()))
    ..registerLazySingleton(() => GetAppSettingsUseCase(repository: getIt()))
    ..registerLazySingleton(() => SaveAppSettingsUseCase(repository: getIt()))
    ..registerLazySingleton(() => CompleteOnboardingUseCase(repository: getIt()));
}

void _cubits() {
  getIt
    ..registerFactory<AuthCubit>(
      () => AuthCubit(
        setPinCode: getIt(),
        getSecuritySettings: getIt(),
        toggleBiometrics: getIt(),
        checkBiometricAvailability: getIt(),
      ),
    )
    ..registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getAppSettings: getIt(),
        saveAppSettings: getIt(),
      ),
    )
    ..registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        completeOnboarding: getIt(),
        getOnboardingProgress: getIt(),
        setOnboardingProgress: getIt(),
      ),
    );
}
