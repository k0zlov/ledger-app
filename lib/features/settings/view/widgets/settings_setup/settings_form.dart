import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/features/settings/view/screens/settings_setup_screen.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    required this.selectedLanguage,
    required this.selectedCurrency,
    required this.onLanguagePressed,
    required this.onCurrencyPressed,
    super.key,
  });

  final VoidCallback onLanguagePressed;
  final VoidCallback onCurrencyPressed;

  final AppLanguage selectedLanguage;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection.insetGrouped(
      children: [
        _Row(onPressed: onLanguagePressed, title: context.l10n.language, selected: selectedLanguage.displayName),
        _Row(onPressed: onCurrencyPressed, title: context.l10n.currency, selected: selectedCurrency),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.selected,
    required this.onPressed,
    required this.title,
  });

  final String title;
  final VoidCallback onPressed;
  final String selected;

  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
      prefix: Text(title),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Text(selected),
      ),
    );
  }
}
