import 'dart:async';

import 'package:ledger_app/core/contracts/onboarding_status_contract.dart';
import 'package:ledger_app/features/onboarding/data/models/onboarding_progress_model.dart';
import 'package:ledger_app/features/onboarding/data/providers/onboarding_storage_provider.dart';
import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:ledger_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository, OnboardingStatusContract {
  OnboardingRepositoryImpl({required this._storageProvider});

  final OnboardingStorageProvider _storageProvider;
  final StreamController<bool> _onboardingCompleteController = StreamController<bool>.broadcast();

  @override
  bool isOnboardingComplete = false;

  @override
  Stream<bool> get completeStream => _onboardingCompleteController.stream;

  Future<void> initialize() async {
    final String? onboardingCompleteRaw = await _storageProvider.getOnboardingComplete();

    final bool isComplete = onboardingCompleteRaw == 'true';
    _setComplete(isComplete);
  }

  void _setComplete(bool value) {
    if (isOnboardingComplete == value) return;

    isOnboardingComplete = value;
    _onboardingCompleteController.add(value);
  }

  @override
  Future<void> completeOnboarding() async {
    await _storageProvider.setOnboardingComplete('true');

    _setComplete(true);
  }

  @override
  Future<OnboardingProgress> getOnboardingProgress() async {
    final OnboardingProgressModel model = await _storageProvider.getOnboardingProgress();
    return model.toEntity();
  }

  @override
  Future<void> setOnboardingProgress(OnboardingProgress entity) {
    final OnboardingProgressModel model = OnboardingProgressModel.fromEntity(entity);
    return _storageProvider.setOnboardingProgress(model);
  }
}
