import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/navigation/navigation_routes.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:ledger_app/features/onboarding/view/cubit/onboarding_cubit.dart';

typedef OnboardingChildBuilder = Widget Function(void Function() onComplete);

class OnboardingWrapperScreen extends StatelessWidget {
  const OnboardingWrapperScreen({
    required this.builder,
    super.key,
  });

  final OnboardingChildBuilder builder;

  Future<void> _handleStepComplete(BuildContext context) async {
    final OnboardingCubit cubit = context.read<OnboardingCubit>();
    final String? currentRouteName = context.navigator.currentRouteName;

    final OnboardingProgress progress = cubit.state.progress;

    switch (currentRouteName) {
      case final name when name == RouteDefinition.onboarding.name:
        unawaited(context.navigator.push(SettingsSetupRoute()));

      case final name when name == RouteDefinition.settingsSetup.name:
        await cubit.updateProgress(progress.copyWith(hasCompletedSettings: true));
        if (!context.mounted) return;
        unawaited(context.navigator.push(AuthSetupRoute()));

      case final name when name == RouteDefinition.authSetup.name:
        await cubit.updateProgress(progress.copyWith(hasCompletedSecurity: true));
        if (!context.mounted) return;
        unawaited(context.navigator.push(AccountsSetupRoute()));

      case final name when name == RouteDefinition.accountsSetup.name:
        await cubit.updateProgress(progress.copyWith(hasCompletedAccounts: true));
        if (!context.mounted) return;
        unawaited(context.navigator.push(CategoriesSetupRoute()));

      case final name when name == RouteDefinition.categoriesSetup.name:
        await cubit.updateProgress(progress.copyWith(hasCompletedCategories: true));
        if (!context.mounted) return;
        unawaited(context.navigator.push(TransactionsSetupRoute()));

      case final name when name == RouteDefinition.transactionsSetup.name:
        await cubit.updateProgress(progress.copyWith(hasCompletedTransactions: true));
        await cubit.completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return builder(() {
      unawaited(_handleStepComplete(context));
    });
  }
}
