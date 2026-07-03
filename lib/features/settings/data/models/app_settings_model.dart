import 'package:ledger_app/features/settings/domain/entities/app_settings.dart';
import 'package:meta/meta.dart';

@immutable
class AppSettingsModel {
  const AppSettingsModel({
    this.currency,
    this.language,
    this.theme,
  });

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      currency: entity.currency,
      language: entity.language.name,
      theme: entity.theme.name,
    );
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      currency: json['currency'] as String?,
      language: json['language'] as String?,
      theme: json['theme'] as String?,
    );
  }

  final String? currency;
  final String? language;
  final String? theme;

  AppSettings toEntity() {
    return AppSettings(
      currency: currency ?? AppSettings.defaultCurrency,
      language: AppLanguage.values.firstWhere(
        (e) => e.name == language,
        orElse: () => AppSettings.defaultLanguage,
      ),
      theme: AppTheme.values.firstWhere(
        (e) => e.name == theme,
        orElse: () => AppSettings.defaultTheme,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'language': language,
      'theme': theme,
    };
  }
}
