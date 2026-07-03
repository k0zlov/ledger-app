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

    if (currentRouteName == RouteDefinition.authSetup.name) {
      await cubit.updateProgress(hasCompletedSecurity: true);
    } else if (currentRouteName == RouteDefinition.settingsSetup.name) {
      await cubit.updateProgress(hasCompletedSettings: true);
    } else if (currentRouteName == RouteDefinition.accountsSetup.name) {
      await cubit.updateProgress(hasCompletedAccounts: true);
    }

    if (!context.mounted) return;

    final OnboardingProgress progress = cubit.state.progress;

    if (!progress.hasCompletedSecurity) {
      unawaited(context.navigator.push(AuthSetupRoute()));
    } else if (!progress.hasCompletedSettings) {
      unawaited(context.navigator.push(SettingsSetupRoute()));
    } else if (!progress.hasCompletedAccounts) {
      unawaited(context.navigator.push(AccountsSetupRoute()));
    } else {
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
