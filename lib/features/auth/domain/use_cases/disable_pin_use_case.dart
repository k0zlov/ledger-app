import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class DisablePinParams {
  const DisablePinParams({
    required this.pin,
    required this.currentSettings,
  });

  final String pin;
  final SecuritySettings currentSettings;
}

class DisablePinUseCase implements UseCase<SecuritySettings?, DisablePinParams> {
  const DisablePinUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SecuritySettings?>> call(DisablePinParams params) async {
    try {
      final isValid = await _repository.checkPin(params.pin);

      if (!isValid) {
        return const Right(null);
      }

      await _repository.deletePinCode();

      final updatedSettings = params.currentSettings.copyWith(
        isSecurityEnabled: false,
        isBiometricsEnabled: false,
      );

      await _repository.updateSecuritySettings(updatedSettings);

      return Right(updatedSettings);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
