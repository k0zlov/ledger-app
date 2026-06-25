import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerDependencies() async {
  _secureStorage();
}

void _secureStorage() {
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorageImpl(
      storage: const FlutterSecureStorage(iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock)),
    ),
  );
}
