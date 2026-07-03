import 'package:local_auth/local_auth.dart';

abstract interface class AuthBiometricProvider {
  Future<bool> isAvailable();

  Future<bool> authenticate(String reason);
}

class AuthBiometricProviderImpl implements AuthBiometricProvider {
  const AuthBiometricProviderImpl({required this._localAuth});

  final LocalAuthentication _localAuth;

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      final bool canCheck = await _localAuth.canCheckBiometrics;
      final bool isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      return false;
    }
  }
}
