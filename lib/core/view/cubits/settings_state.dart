part of 'settings_cubit.dart';

@immutable
class SettingsState {
  const SettingsState({
    this.appSettings = const AppSettings(),
  });

  final AppSettings appSettings;

  SettingsState copyWith({
    AppSettings? appSettings,
  }) {
    return SettingsState(
      appSettings: appSettings ?? this.appSettings,
    );
  }
}
