abstract interface class OnboardingStatusContract {
  bool get isOnboardingComplete;

  Stream<bool> get completeStream;
}
