import 'package:ledger_app/core/domain/entities/app_settings.dart';

extension AppLanguageX on AppLanguage {
  String get displayName {
    switch (this) {
      case AppLanguage.en:
        return 'EN - English';
      case AppLanguage.ua:
        return 'UA - Українська';
      case AppLanguage.ru:
        return 'RU - Русский';
    }
  }
}
