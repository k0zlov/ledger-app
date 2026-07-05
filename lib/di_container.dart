import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/contracts/auth_state_contract.dart';
import 'package:ledger_app/core/contracts/onboarding_status_contract.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/domain/repositories/account_repository.dart';
import 'package:ledger_app/core/domain/repositories/category_repository.dart';
import 'package:ledger_app/core/domain/repositories/transaction_repository.dart';
import 'package:ledger_app/core/domain/use_cases/watch_accounts_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_categories_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_transactions_use_case.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/navigation/router.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:ledger_app/features/accounts/data/providers/account_storage_provider.dart';
import 'package:ledger_app/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:ledger_app/features/accounts/domain/use_cases/add_account_use_case.dart';
import 'package:ledger_app/features/accounts/domain/use_cases/delete_account_use_case.dart';
import 'package:ledger_app/features/accounts/domain/use_cases/update_account_use_case.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/auth/data/providers/auth_biometric_provider.dart';
import 'package:ledger_app/features/auth/data/providers/auth_storage_provider.dart';
import 'package:ledger_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ledger_app/features/auth/domain/use_cases/authenticate_with_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/authenticate_with_pin_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/check_biometric_availability_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/get_security_settings_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/set_pin_code_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/toggle_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/categories/data/providers/category_storage_provider.dart';
import 'package:ledger_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:ledger_app/features/categories/domain/use_cases/create_category_use_case.dart';
import 'package:ledger_app/features/categories/domain/use_cases/delete_category_use_case.dart';
import 'package:ledger_app/features/categories/domain/use_cases/update_category_use_case.dart';
import 'package:ledger_app/features/categories/view/cubit/categories_cubit.dart';
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
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/features/transactions/data/providers/transaction_storage_provider.dart';
import 'package:ledger_app/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:ledger_app/features/transactions/domain/use_cases/create_transaction_use_case.dart';
import 'package:ledger_app/features/transactions/domain/use_cases/delete_transaction_use_case.dart';
import 'package:ledger_app/features/transactions/domain/use_cases/update_transaction_use_case.dart';
import 'package:ledger_app/features/transactions/view/cubit/transactions_cubit.dart';
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
    ..registerLazySingleton<AccountStorageProvider>(
      () => AccountStorageProviderImpl(db: getIt()),
    )
    ..registerLazySingleton<CategoryStorageProvider>(
      () => CategoryStorageProviderImpl(db: getIt()),
    )
    ..registerLazySingleton<TransactionStorageProvider>(
      () => TransactionStorageProviderImpl(db: getIt()),
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
    ..registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(storageProvider: getIt()))
    ..registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(storageProvider: getIt()))
    ..registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(storageProvider: getIt()))
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
    ..registerLazySingleton(() => WatchAccountsUseCase(repository: getIt()))
    ..registerLazySingleton(() => AddAccountUseCase(repository: getIt()))
    ..registerLazySingleton(() => DeleteAccountUseCase(repository: getIt()))
    ..registerLazySingleton(() => UpdateAccountUseCase(repository: getIt()))
    ..registerLazySingleton(() => CreateCategoryUseCase(repository: getIt()))
    ..registerLazySingleton(() => DeleteCategoryUseCase(repository: getIt()))
    ..registerLazySingleton(() => UpdateCategoryUseCase(repository: getIt()))
    ..registerLazySingleton(() => WatchCategoriesUseCase(repository: getIt()))
    ..registerLazySingleton(() => CreateTransactionUseCase(repository: getIt()))
    ..registerLazySingleton(() => UpdateTransactionUseCase(repository: getIt()))
    ..registerLazySingleton(() => DeleteTransactionUseCase(repository: getIt()))
    ..registerLazySingleton(() => WatchTransactionsUseCase(repository: getIt()))
    ..registerLazySingleton(() => AuthenticateWithPinUseCase(repository: getIt()))
    ..registerLazySingleton(() => AuthenticateWithBiometricsUseCase(repository: getIt()))
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
        authenticateWithBiometrics: getIt(),
        authenticateWithPin: getIt(),
      ),
    )
    ..registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getAppSettings: getIt(),
        saveAppSettings: getIt(),
      ),
    )
    ..registerFactory<AccountsCubit>(
      () => AccountsCubit(
        watchAccounts: getIt(),
        addAccount: getIt(),
        deleteAccount: getIt(),
        updateAccount: getIt(),
      ),
    )
    ..registerFactory<CategoriesCubit>(
      () => CategoriesCubit(
        watchCategories: getIt(),
        createCategory: getIt(),
        deleteCategory: getIt(),
        updateCategory: getIt(),
      ),
    )
    ..registerFactory<TransactionsCubit>(
      () => TransactionsCubit(
        watchTransactions: getIt(),
        watchAccounts: getIt(),
        watchCategories: getIt(),
        createTransaction: getIt(),
        deleteTransaction: getIt(),
        updateTransaction: getIt(),
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
