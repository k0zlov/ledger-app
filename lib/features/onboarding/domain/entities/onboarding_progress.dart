import 'package:flutter/cupertino.dart';

@immutable
class OnboardingProgress {
  const OnboardingProgress({
    this.hasCompletedSecurity = false,
    this.hasCompletedSettings = false,
    this.hasCompletedAccounts = false,
    this.hasCompletedCategories = false,
    this.hasCompletedTransactions = false,
  });

  final bool hasCompletedSecurity;
  final bool hasCompletedSettings;
  final bool hasCompletedAccounts;
  final bool hasCompletedCategories;
  final bool hasCompletedTransactions;

  OnboardingProgress copyWith({
    bool? hasCompletedSecurity,
    bool? hasCompletedSettings,
    bool? hasCompletedAccounts,
    bool? hasCompletedCategories,
    bool? hasCompletedTransactions,
  }) {
    return OnboardingProgress(
      hasCompletedSecurity: hasCompletedSecurity ?? this.hasCompletedSecurity,
      hasCompletedSettings: hasCompletedSettings ?? this.hasCompletedSettings,
      hasCompletedAccounts: hasCompletedAccounts ?? this.hasCompletedAccounts,
      hasCompletedCategories: hasCompletedCategories ?? this.hasCompletedCategories,
      hasCompletedTransactions: hasCompletedTransactions ?? this.hasCompletedTransactions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingProgress &&
          runtimeType == other.runtimeType &&
          hasCompletedSecurity == other.hasCompletedSecurity &&
          hasCompletedSettings == other.hasCompletedSettings &&
          hasCompletedAccounts == other.hasCompletedAccounts &&
          hasCompletedCategories == other.hasCompletedCategories &&
          hasCompletedTransactions == other.hasCompletedTransactions;

  @override
  int get hashCode => Object.hash(
    hasCompletedSecurity,
    hasCompletedSettings,
    hasCompletedAccounts,
    hasCompletedCategories,
    hasCompletedTransactions,
  );
}
