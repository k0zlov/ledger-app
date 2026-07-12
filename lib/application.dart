import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/localization/generated/app_localizations.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';

class Application extends StatelessWidget {
  const Application({required this.router, super.key});

  final GoRouter router;

  CupertinoThemeData _getCupertinoTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return const CupertinoThemeData(brightness: Brightness.light);
      case AppTheme.dark:
        return const CupertinoThemeData(brightness: Brightness.dark);
      case AppTheme.system:
        return const CupertinoThemeData();
    }
  }

  Locale _mapLocale(AppLanguage language) {
    switch (language) {
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.ua:
        return const Locale('uk');
      case AppLanguage.ru:
        return const Locale('ru');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.appSettings.theme != current.appSettings.theme ||
          previous.appSettings.language != current.appSettings.language,
      builder: (context, state) {
        return CupertinoApp.router(
          title: 'Ledger',
          locale: _mapLocale(state.appSettings.language),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: _getCupertinoTheme(state.appSettings.theme),
        );
      },
    );
  }
}
