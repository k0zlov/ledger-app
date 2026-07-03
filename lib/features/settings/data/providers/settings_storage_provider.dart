import 'dart:convert';

import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:ledger_app/features/settings/data/models/app_settings_model.dart';

abstract interface class SettingsStorageProvider {
  Future<void> saveAppSettings(AppSettingsModel model);

  Future<AppSettingsModel> getAppSettings();
}

class SettingsStorageProviderImpl implements SettingsStorageProvider {
  const SettingsStorageProviderImpl({required this._secureStorage});

  final SecureStorage _secureStorage;

  @override
  Future<AppSettingsModel> getAppSettings() async {
    final String? jsonString = await _secureStorage.read(SecureStorageKey.appSettings);
    if (jsonString == null) return const AppSettingsModel();

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettingsModel.fromJson(map);
    } catch (e) {
      return const AppSettingsModel();
    }
  }

  @override
  Future<void> saveAppSettings(AppSettingsModel model) async {
    final String jsonString = jsonEncode(model.toJson());
    await _secureStorage.write(SecureStorageKey.appSettings, value: jsonString);
  }
}
