import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/localization/generated/app_localizations.dart';

extension LocalizationBuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
