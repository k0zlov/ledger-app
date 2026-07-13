import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';

abstract interface class AuthRepository {
  Future<SecuritySettings> getSecuritySettings();

  Future<void> updateSecuritySettings(SecuritySettings settings);

  Future<void> setPinCode(String pin);

  Future<bool> authenticateWithPin(String pin);

  Future<bool> checkBiometricsAvailability();

  Future<bool> authenticateWithBiometrics(String reason);

  Future<bool> checkPin(String pin);

  Future<void> deletePinCode();
}
