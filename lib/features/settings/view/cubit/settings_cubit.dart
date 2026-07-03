import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/settings/domain/entities/app_settings.dart';
import 'package:ledger_app/features/settings/domain/use_cases/get_app_settings_use_case.dart';
import 'package:ledger_app/features/settings/domain/use_cases/save_app_settings_use_case.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this._getAppSettings,
    required this._saveAppSettings,
  }) : super(const SettingsState());

  final GetAppSettingsUseCase _getAppSettings;
  final SaveAppSettingsUseCase _saveAppSettings;

  Future<void> initialize() async {
    final result = await _getAppSettings(NoParams());

    result.fold(
      (failure) {},
      (settings) => emit(state.copyWith(appSettings: settings)),
    );
  }

  Future<void> setAppSettings({
    String? currency,
    AppLanguage? language,
    AppTheme? theme,
  }) async {
    final AppSettings newSettings = state.appSettings.copyWith(
      currency: currency,
      language: language,
      theme: theme,
    );

    if (state.appSettings == newSettings) return;

    final result = await _saveAppSettings(newSettings);

    result.fold(
      (failure) {},
      (_) => emit(state.copyWith(appSettings: newSettings)),
    );
  }
}
