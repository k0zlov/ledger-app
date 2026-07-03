import 'package:ledger_app/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> getAppSettings();

  Future<void> saveAppSettings(AppSettings entity);
}
