import 'package:flutter/foundation.dart';
import 'package:ledger_app/core/secure_storage/secure_storage.dart';

enum AppStatus {
  uninitialized,
  onboarding,
  locked,
  ready,
}

abstract interface class AppStatusService {
  ValueListenable<AppStatus> get statusListenable;

  AppStatus get currentStatus;

  void completeOnboarding();

  void unlockApp();

  void lockApp();

  Future<void> initialize();
}

class AppStatusServiceImpl implements AppStatusService {
  AppStatusServiceImpl({required this.secureStorage});

  final SecureStorage secureStorage;

  final ValueNotifier<AppStatus> _statusNotifier = ValueNotifier<AppStatus>(AppStatus.uninitialized);

  @override
  Future<void> initialize() async {
    try {
      final String? onboardingFlag = await secureStorage.read(SecureStorageKey.onboardingComplete);

      bool isTrue(String? value) => value == 'true';

      if (!isTrue(onboardingFlag)) {
        _setStatus(AppStatus.onboarding);
        return;
      }

      final String? securityFlag = await secureStorage.read(SecureStorageKey.securityEnabled);

      if (isTrue(securityFlag)) {
        _setStatus(AppStatus.locked);
        return;
      }
      _setStatus(AppStatus.ready);
    } catch (e) {
      _setStatus(AppStatus.onboarding);
    }
  }

  @override
  AppStatus get currentStatus => _statusNotifier.value;

  @override
  ValueListenable<AppStatus> get statusListenable => _statusNotifier;

  void _setStatus(AppStatus status) {
    if (status == currentStatus) return;

    _statusNotifier.value = status;
  }

  @override
  Future<void> completeOnboarding() async {
    await secureStorage.write(SecureStorageKey.onboardingComplete, value: 'true');
    _setStatus(AppStatus.ready);
  }

  @override
  void unlockApp() {
    if (currentStatus == AppStatus.locked) {
      _setStatus(AppStatus.ready);
    }
  }

  @override
  void lockApp() {
    if (currentStatus == AppStatus.ready) {
      _setStatus(AppStatus.locked);
    }
  }
}
