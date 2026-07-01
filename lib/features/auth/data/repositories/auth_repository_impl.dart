import 'package:ledger_app/features/auth/data/providers/auth_provider.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this._authProvider});

  final AuthProvider _authProvider;

  @override
  Future<void> setupPinCode(String pin) async {
    await _authProvider.enableSecurity(pin);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    return _authProvider.verifyPin(pin);
  }

  @override
  Future<bool> checkBiometricsAvailability() async {
    return _authProvider.isBiometricsAvailable();
  }

  @override
  Future<bool> enableBiometrics(String reason) async {
    return _authProvider.authenticateWithBiometrics(reason);
  }
}
