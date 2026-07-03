import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class SetPinCodeParams {
  const SetPinCodeParams({
    required this.pin,
    required this.currentSettings,
  });

  final String pin;
  final SecuritySettings currentSettings;
}

class SetPinCodeUseCase implements UseCase<SecuritySettings?, SetPinCodeParams> {
  const SetPinCodeUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SecuritySettings?>> call(SetPinCodeParams params) async {
    if (params.pin.length != 4) {
      return const Left(
        CacheFailure(errorMessage: 'PIN must be exactly 4 digits long'),
      );
    }

    try {
      await _repository.setPinCode(params.pin);

      if (!params.currentSettings.isBiometricsEnabled) {
        final SecuritySettings updatedSettings = params.currentSettings.copyWith(isSecurityEnabled: true);

        await _repository.updateSecuritySettings(updatedSettings);

        return Right(updatedSettings);
      }

      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Failed to securely save PIN: $e'),
      );
    }
  }
}
