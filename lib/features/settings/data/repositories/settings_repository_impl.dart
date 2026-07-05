import 'package:ledger_app/core/data/models/app_settings_model.dart';
import 'package:ledger_app/features/settings/data/providers/settings_storage_provider.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this._storageProvider});

  final SettingsStorageProvider _storageProvider;

  @override
  Future<AppSettings> getAppSettings() async {
    final AppSettingsModel model = await _storageProvider.getAppSettings();
    return model.toEntity();
  }

  @override
  Future<void> saveAppSettings(AppSettings entity) {
    final AppSettingsModel model = AppSettingsModel.fromEntity(entity);
    return _storageProvider.saveAppSettings(model);
  }
}
