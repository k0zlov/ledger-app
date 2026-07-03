import 'dart:async';

import 'package:ledger_app/core/contracts/auth_state_contract.dart';
import 'package:ledger_app/features/auth/data/models/security_settings_model.dart';
import 'package:ledger_app/features/auth/data/providers/auth_biometric_provider.dart';
import 'package:ledger_app/features/auth/data/providers/auth_storage_provider.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository, AuthStatusContract {
  AuthRepositoryImpl({
    required this._biometricProvider,
    required this._storageProvider,
  });

  final AuthBiometricProvider _biometricProvider;
  final AuthStorageProvider _storageProvider;

  final StreamController<bool> _lockStateController = StreamController<bool>.broadcast();

  @override
  bool isLocked = true;

  @override
  Stream<bool> get lockStateStream => _lockStateController.stream;

  Future<void> initialize() async {
    final SecuritySettingsModel model = await _storageProvider.getSettings();
    final SecuritySettings entity = model.toEntity();

    _setLocked(entity.isSecurityEnabled);
  }

  void _setLocked(bool value) {
    if (isLocked == value) return;

    isLocked = value;
    _lockStateController.add(value);
  }

  @override
  Future<bool> authenticateWithBiometrics(String reason) async {
    final bool result = await _biometricProvider.authenticate(reason);

    if (result) {
      _setLocked(false);
    }

    return result;
  }

  @override
  Future<bool> authenticateWithPin(String pin) async {
    final String? storedPin = await _storageProvider.getPin();
    final bool isMatch = storedPin == pin;

    if (isMatch) {
      _setLocked(false);
    }

    return isMatch;
  }

  @override
  Future<void> setPinCode(String pin) async {
    await _storageProvider.savePin(pin);
    _setLocked(false);
  }

  @override
  Future<void> updateSecuritySettings(SecuritySettings settings) async {
    await _storageProvider.saveSettings(SecuritySettingsModel.fromEntity(settings));

    if (!settings.isSecurityEnabled) {
      _setLocked(false);
    }
  }

  @override
  Future<bool> checkBiometricsAvailability() async {
    return _biometricProvider.isAvailable();
  }

  @override
  Future<SecuritySettings> getSecuritySettings() async {
    final SecuritySettingsModel model = await _storageProvider.getSettings();
    return model.toEntity();
  }
}
