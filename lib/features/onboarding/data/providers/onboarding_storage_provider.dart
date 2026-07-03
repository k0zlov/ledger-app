import 'dart:convert';

import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:ledger_app/features/onboarding/data/models/onboarding_progress_model.dart';

abstract interface class OnboardingStorageProvider {
  Future<String?> getOnboardingComplete();

  Future<void> setOnboardingComplete(String value);

  Future<OnboardingProgressModel> getOnboardingProgress();

  Future<void> setOnboardingProgress(OnboardingProgressModel model);
}

class OnboardingStorageProviderImpl implements OnboardingStorageProvider {
  const OnboardingStorageProviderImpl({required this._secureStorage});

  final SecureStorage _secureStorage;

  @override
  Future<String?> getOnboardingComplete() {
    return _secureStorage.read(SecureStorageKey.onboardingComplete);
  }

  @override
  Future<void> setOnboardingComplete(String value) async {
    await _secureStorage.write(SecureStorageKey.onboardingComplete, value: value);
  }

  @override
  Future<OnboardingProgressModel> getOnboardingProgress() async {
    final String? jsonString = await _secureStorage.read(SecureStorageKey.onboardingProgress);
    if (jsonString == null) return const OnboardingProgressModel();

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return OnboardingProgressModel.fromJson(map);
    } catch (e) {
      return const OnboardingProgressModel();
    }
  }

  @override
  Future<void> setOnboardingProgress(OnboardingProgressModel model) {
    return _secureStorage.write(
      SecureStorageKey.onboardingProgress,
      value: jsonEncode(model.toJson()),
    );
  }
}
