import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';

abstract interface class OnboardingRepository {
  Future<void> completeOnboarding();

  Future<OnboardingProgress> getOnboardingProgress();

  Future<void> setOnboardingProgress(OnboardingProgress entity);
}
