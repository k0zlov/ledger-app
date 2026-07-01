abstract interface class AuthRepository {
  Future<void> setupPinCode(String pin);

  Future<bool> verifyPin(String pin);

  Future<bool> checkBiometricsAvailability();

  Future<bool> enableBiometrics(String reason);
}
