import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class ToggleBiometricsParams {
  const ToggleBiometricsParams({
    required this.reason,
    required this.currentSettings,
  });

  final String reason;
  final SecuritySettings currentSettings;
}

class ToggleBiometricsUseCase implements UseCase<SecuritySettings, ToggleBiometricsParams> {
  const ToggleBiometricsUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SecuritySettings>> call(ToggleBiometricsParams params) async {
    try {
      final bool targetState = !params.currentSettings.isBiometricsEnabled;

      if (targetState) {
        final bool authenticated = await _repository.authenticateWithBiometrics(params.reason);

        if (authenticated) {
          final SecuritySettings updatedSettings = params.currentSettings.copyWith(isBiometricsEnabled: true);
          await _repository.updateSecuritySettings(updatedSettings);

          return Right(updatedSettings);
        } else {
          return const Left(
            CacheFailure(errorMessage: 'Biometric authentication failed or was canceled.'),
          );
        }
      } else {
        final SecuritySettings updatedSettings = params.currentSettings.copyWith(isBiometricsEnabled: false);
        await _repository.updateSecuritySettings(updatedSettings);

        return Right(updatedSettings);
      }
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Native biometric prompt failed: $e'),
      );
    }
  }
}
