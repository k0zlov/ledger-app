import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/core/view/extensions/app_language_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';
import 'package:ledger_app/features/settings/view/widgets/settings/selection_item.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLanguage = context.select<SettingsCubit, AppLanguage>((cubit) => cubit.state.appSettings.language);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar:  CupertinoNavigationBar(
        middle: Text(l10n.language),
        previousPageTitle: l10n.settings,
      ),
      child: SafeArea(
        child: ListSection(
          children: AppLanguage.values.map((language) {
            return SelectionItem(
              title: language.displayName,
              isSelected: currentLanguage == language,
              onTap: () => context.read<SettingsCubit>().setAppSettings(language: language),
            );
          }).toList(),
        ),
      ),
    );
  }
}
