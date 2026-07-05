import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';

class OnboardingProgressModel {
  const OnboardingProgressModel({
    this.hasCompletedSecurity,
    this.hasCompletedSettings,
    this.hasCompletedAccounts,
    this.hasCompletedCategories,
    this.hasCompletedTransactions,
  });

  factory OnboardingProgressModel.fromJson(Map<String, dynamic> map) {
    return OnboardingProgressModel(
      hasCompletedSecurity: map['hasCompletedSecurity'] as String?,
      hasCompletedSettings: map['hasCompletedSettings'] as String?,
      hasCompletedAccounts: map['hasCompletedAccounts'] as String?,
      hasCompletedCategories: map['hasCompletedCategories'] as String?,
      hasCompletedTransactions: map['hasCompletedTransactions'] as String?,
    );
  }

  factory OnboardingProgressModel.fromEntity(OnboardingProgress entity) {
    return OnboardingProgressModel(
      hasCompletedSecurity: entity.hasCompletedSecurity.toString(),
      hasCompletedSettings: entity.hasCompletedSettings.toString(),
      hasCompletedAccounts: entity.hasCompletedAccounts.toString(),
      hasCompletedCategories: entity.hasCompletedCategories.toString(),
      hasCompletedTransactions: entity.hasCompletedTransactions.toString(),
    );
  }

  final String? hasCompletedSecurity;
  final String? hasCompletedSettings;
  final String? hasCompletedAccounts;
  final String? hasCompletedCategories;
  final String? hasCompletedTransactions;

  OnboardingProgress toEntity() {
    return OnboardingProgress(
      hasCompletedSecurity: hasCompletedSecurity == 'true',
      hasCompletedSettings: hasCompletedSettings == 'true',
      hasCompletedAccounts: hasCompletedAccounts == 'true',
      hasCompletedCategories: hasCompletedCategories == 'true',
      hasCompletedTransactions: hasCompletedTransactions == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasCompletedSecurity': hasCompletedSecurity,
      'hasCompletedSettings': hasCompletedSettings,
      'hasCompletedAccounts': hasCompletedAccounts,
      'hasCompletedCategories': hasCompletedCategories,
      'hasCompletedTransactions': hasCompletedTransactions,
    };
  }
}
