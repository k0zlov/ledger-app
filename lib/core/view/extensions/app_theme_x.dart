import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/localization/generated/app_localizations.dart';

extension AppThemeX on AppTheme {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case AppTheme.light:
        return l10n.themeLight;
      case AppTheme.dark:
        return l10n.themeDark;
      case AppTheme.system:
        return l10n.themeSystem;
    }
  }
}
