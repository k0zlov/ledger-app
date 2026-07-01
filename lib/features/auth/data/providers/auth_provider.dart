import 'package:ledger_app/core/secure_storage/secure_storage.dart';
import 'package:local_auth/local_auth.dart';

abstract interface class AuthProvider {
  Future<void> enableSecurity(String pin);

  Future<bool> verifyPin(String pin);

  Future<bool> isBiometricsAvailable();

  Future<bool> authenticateWithBiometrics(String reason);
}

class AuthProviderImpl implements AuthProvider {
  const AuthProviderImpl({required this._localAuth, required this._secureStorage});

  final LocalAuthentication _localAuth;
  final SecureStorage _secureStorage;

  @override
  Future<bool> authenticateWithBiometrics(String reason) async {
    try {
      return _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final bool canAuthenticate = await _localAuth.isDeviceSupported();

      return canAuthenticateWithBiometrics && canAuthenticate;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> enableSecurity(String pin) async {
    await _secureStorage.write(SecureStorageKey.securityPinCode, value: pin);
    await _secureStorage.write(SecureStorageKey.securityEnabled, value: true.toString());
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final String? storedPin = await _secureStorage.read(SecureStorageKey.securityPinCode);
    return storedPin == pin;
  }
}
