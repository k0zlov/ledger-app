import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';

final GetIt getIt = GetIt.instance;

Future<void> registerDependencies() async {
  _database();
  _secureStorage();
}

void _database() {
  getIt.registerLazySingleton(Database.new);
}

void _secureStorage() {
  getIt.registerLazySingleton<SecureStorage>(
    () => SecureStorageImpl(
      storage: const FlutterSecureStorage(iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock)),
    ),
  );
}
