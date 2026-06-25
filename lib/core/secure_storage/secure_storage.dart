import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecureStorageKey {
  onboardingComplete,
  securityEnabled,
}

abstract interface class SecureStorage {
  Future<void> write(SecureStorageKey key, {required String value});

  Future<String?> read(SecureStorageKey key);

  Future<void> delete(SecureStorageKey key);

  Future<void> deleteAll();
}

class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl({required this.storage});

  final FlutterSecureStorage storage;

  @override
  Future<String?> read(SecureStorageKey key) {
    return storage.read(key: key.name);
  }

  @override
  Future<void> write(SecureStorageKey key, {required String value}) {
    return storage.write(key: key.name, value: value);
  }

  @override
  Future<void> delete(SecureStorageKey key) {
    return storage.delete(key: key.name);
  }

  @override
  Future<void> deleteAll() {
    return storage.deleteAll();
  }
}
