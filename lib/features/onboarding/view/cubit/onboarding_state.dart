part of 'onboarding_cubit.dart';

@immutable
class OnboardingState {
  const OnboardingState({
    this.progress = const OnboardingProgress(),
  });

  final OnboardingProgress progress;

  OnboardingState copyWith({
    OnboardingProgress? progress,
  }) {
    return OnboardingState(
      progress: progress ?? this.progress,
    );
  }
}
