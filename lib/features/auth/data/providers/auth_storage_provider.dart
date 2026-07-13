import 'dart:convert';

import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:ledger_app/features/auth/data/models/security_settings_model.dart';

abstract interface class AuthStorageProvider {
  Future<void> savePin(String pin);

  Future<String?> getPin();

  Future<SecuritySettingsModel> getSettings();

  Future<void> saveSettings(SecuritySettingsModel settings);

  Future<void> deletePin();
}

class AuthStorageProviderImpl implements AuthStorageProvider {
  const AuthStorageProviderImpl({required this._secureStorage});

  final SecureStorage _secureStorage;

  @override
  Future<void> savePin(String pin) async {
    await _secureStorage.write(SecureStorageKey.securityPinCode, value: pin);
  }

  @override
  Future<String?> getPin() async {
    return _secureStorage.read(SecureStorageKey.securityPinCode);
  }

  @override
  Future<SecuritySettingsModel> getSettings() async {
    final String? jsonString = await _secureStorage.read(SecureStorageKey.securitySettings);
    if (jsonString == null) return const SecuritySettingsModel();

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return SecuritySettingsModel.fromJson(map);
    } catch (e) {
      return const SecuritySettingsModel();
    }
  }

  @override
  Future<void> saveSettings(SecuritySettingsModel settings) async {
    final String jsonString = jsonEncode(settings.toJson());
    await _secureStorage.write(SecureStorageKey.securitySettings, value: jsonString);
  }

  @override
  Future<void> deletePin() async {
    await _secureStorage.delete(SecureStorageKey.securityPinCode);
  }
}
