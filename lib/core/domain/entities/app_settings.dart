import 'package:meta/meta.dart';

enum AppLanguage { en, ua, ru }

enum AppTheme { system, light, dark }

@immutable
class AppSettings {
  const AppSettings({
    this.currency = defaultCurrency,
    this.language = defaultLanguage,
    this.theme = defaultTheme,
  });

  final String currency;
  final AppLanguage language;
  final AppTheme theme;

  static const String defaultCurrency = 'USD';
  static const AppLanguage defaultLanguage = AppLanguage.en;
  static const AppTheme defaultTheme = AppTheme.system;

  AppSettings copyWith({
    String? currency,
    AppLanguage? language,
    AppTheme? theme,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      language: language ?? this.language,
      theme: theme ?? this.theme,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          currency == other.currency &&
          language == other.language &&
          theme == other.theme;

  @override
  int get hashCode => Object.hash(currency, language, theme);
}
