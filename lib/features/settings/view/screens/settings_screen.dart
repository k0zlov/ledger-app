import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/navigation/navigation_routes.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/core/view/extensions/app_theme_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _onCurrencyTap(BuildContext context, String currentCurrency) async {
    final selectedCurrency = await context.navigator.push<String>(
      CurrencySelectionRoute(selectedCurrency: currentCurrency),
    );

    if (selectedCurrency != null && selectedCurrency != currentCurrency) {
      if (!context.mounted) return;
      await context.read<SettingsCubit>().setAppSettings(currency: selectedCurrency);
    }
  }

  Future<void> _onThemeTap(BuildContext context) async {
    await context.navigator.push(ThemeSelectionRoute());
  }

  Future<void> _onLanguageTap(BuildContext context) async {
    await context.navigator.push(LanguageSelectionRoute());
  }

  Future<void> _onAccountsTap(BuildContext context) async {
    await context.navigator.push(AccountsRoute());
  }

  Future<void> _onCategoriesTap(BuildContext context) async {
    await context.navigator.push(CategoriesRoute());
  }

  Future<void> _onAppInfoTap(BuildContext context) async {
    await context.navigator.push(AppInfoRoute());
  }

  Future<void> _onHelpAndSupportTap(BuildContext context) async {
    await context.navigator.push(HelpAndSupportRoute());
  }

  Future<void> _onAuthSettingsTap(BuildContext context) async {
    await context.navigator.push(AuthSettingsRoute());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appSettings = context.select<SettingsCubit, AppSettings>((cubit) => cubit.state.appSettings);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(l10n.settings),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ListSection(
                  title: l10n.accountSection,
                  children: [
                    SettingsItem(
                      title: l10n.authSecurity,
                      icon: CupertinoIcons.person_solid,
                      iconBackgroundColor: CupertinoColors.activeBlue,
                      onTap: () => _onAuthSettingsTap(context),
                    ),
                  ],
                ),
                ListSection(
                  title: l10n.generalSection,
                  children: [
                    SettingsItem(
                      title: l10n.appearance,
                      subtitle: appSettings.theme.localizedName(l10n).toUpperCase(),
                      icon: CupertinoIcons.paintbrush_fill,
                      iconBackgroundColor: CupertinoColors.systemPurple,
                      onTap: () => _onThemeTap(context),
                    ),
                    SettingsItem(
                      title: l10n.language,
                      subtitle: appSettings.language.name.toUpperCase(),
                      icon: CupertinoIcons.globe,
                      iconBackgroundColor: CupertinoColors.systemBlue,
                      onTap: () => _onLanguageTap(context),
                    ),
                    SettingsItem(
                      title: l10n.currency,
                      subtitle: appSettings.currency,
                      icon: CupertinoIcons.money_dollar_circle_fill,
                      iconBackgroundColor: CupertinoColors.systemGreen,
                      onTap: () => _onCurrencyTap(context, appSettings.currency),
                    ),
                  ],
                ),
                ListSection(
                  title: l10n.managementSection,
                  children: [
                    SettingsItem(
                      title: l10n.accounts,
                      icon: CupertinoIcons.creditcard_fill,
                      iconBackgroundColor: CupertinoColors.systemOrange,
                      onTap: () => _onAccountsTap(context),
                    ),
                    SettingsItem(
                      title: l10n.categories,
                      icon: CupertinoIcons.square_grid_2x2_fill,
                      iconBackgroundColor: CupertinoColors.systemPink,
                      onTap: () => _onCategoriesTap(context),
                    ),
                  ],
                ),
                ListSection(
                  title: l10n.aboutSection,
                  children: [
                    SettingsItem(
                      title: l10n.helpSupport,
                      icon: CupertinoIcons.question_circle_fill,
                      iconBackgroundColor: CupertinoColors.activeGreen,
                      onTap: () => _onHelpAndSupportTap(context),
                    ),
                    SettingsItem(
                      title: l10n.appInfo,
                      icon: CupertinoIcons.info_circle_fill,
                      iconBackgroundColor: CupertinoColors.systemGrey,
                      onTap: () => _onAppInfoTap(context),
                    ),
                  ],
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    required this.title,
    required this.icon,
    required this.iconBackgroundColor,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
      ),
      additionalInfo: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          : null,
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            icon,
            color: CupertinoColors.white,
            size: 18,
          ),
        ),
      ),
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) => onTap());
      },
    );
  }
}
