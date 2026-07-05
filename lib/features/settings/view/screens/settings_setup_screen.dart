import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/features/settings/view/screens/currency_selection_screen.dart';
import 'package:ledger_app/features/settings/view/widgets/settings_setup/continue_button.dart';
import 'package:ledger_app/features/settings/view/widgets/settings_setup/settings_form.dart';

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

class SettingsSetupScreen extends StatelessWidget {
  const SettingsSetupScreen({
    required this.onSetupComplete,
    super.key,
  });

  final VoidCallback onSetupComplete;

  Future<void> _showLanguagePicker(BuildContext context, AppLanguage current) async {
    const items = AppLanguage.values;
    final initialIndex = items.indexOf(current);

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 200,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            itemExtent: 32,
            scrollController: FixedExtentScrollController(initialItem: initialIndex),
            onSelectedItemChanged: (i) async {
              await context.read<SettingsCubit>().setAppSettings(language: items[i]);
            },
            children: items.map((e) => Center(child: Text(e.displayName))).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _showCurrencyPicker(BuildContext context, String currentCurrency) async {
    final String? selectedCurrency = await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => CurrencySelectionScreen(selectedCurrency: currentCurrency),
    );

    if (selectedCurrency != null && selectedCurrency != currentCurrency) {
      if (!context.mounted) return;
      await context.read<SettingsCubit>().setAppSettings(currency: selectedCurrency);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.select<SettingsCubit, AppSettings>((c) => c.state.appSettings);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.preferences),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            SettingsForm(
              selectedLanguage: settings.language,
              selectedCurrency: settings.currency,
              onLanguagePressed: () => _showLanguagePicker(context, settings.language),
              onCurrencyPressed: () => _showCurrencyPicker(context, settings.currency),
            ),
            const Spacer(),
            ContinueButton(onPressed: onSetupComplete),
          ],
        ),
      ),
    );
  }
}
