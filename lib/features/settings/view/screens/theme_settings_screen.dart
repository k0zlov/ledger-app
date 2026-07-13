import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/core/view/extensions/app_theme_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';
import 'package:ledger_app/features/settings/view/widgets/settings/selection_item.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentTheme = context.select<SettingsCubit, AppTheme>((cubit) => cubit.state.appSettings.theme);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.theme),
        previousPageTitle: l10n.backButton,
      ),
      child: SafeArea(
        child: ListSection(
          children: AppTheme.values.map((theme) {
            return SelectionItem(
              title: theme.localizedName(l10n),
              isSelected: currentTheme == theme,
              onTap: () => context.read<SettingsCubit>().setAppSettings(theme: theme),
            );
          }).toList(),
        ),
      ),
    );
  }
}
