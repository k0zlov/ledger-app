import 'package:ledger_app/core/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> getAppSettings();

  Future<void> saveAppSettings(AppSettings entity);
}
