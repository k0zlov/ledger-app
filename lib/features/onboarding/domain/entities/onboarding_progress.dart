import 'package:flutter/cupertino.dart';

@immutable
class OnboardingProgress {
  const OnboardingProgress({
    this.hasCompletedSecurity = false,
    this.hasCompletedSettings = false,
    this.hasCompletedAccounts = false,
  });

  final bool hasCompletedSecurity;
  final bool hasCompletedSettings;
  final bool hasCompletedAccounts;

  OnboardingProgress copyWith({
    bool? hasCompletedSecurity,
    bool? hasCompletedSettings,
    bool? hasCompletedAccounts,
  }) {
    return OnboardingProgress(
      hasCompletedSecurity: hasCompletedSecurity ?? this.hasCompletedSecurity,
      hasCompletedSettings: hasCompletedSettings ?? this.hasCompletedSettings,
      hasCompletedAccounts: hasCompletedAccounts ?? this.hasCompletedAccounts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingProgress &&
          runtimeType == other.runtimeType &&
          hasCompletedSecurity == other.hasCompletedSecurity &&
          hasCompletedSettings == other.hasCompletedSettings &&
          hasCompletedAccounts == other.hasCompletedAccounts;

  @override
  int get hashCode => Object.hash(hasCompletedSecurity, hasCompletedSettings, hasCompletedAccounts);
}
