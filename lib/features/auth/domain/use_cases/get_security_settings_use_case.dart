import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class GetSecuritySettingsUseCase implements UseCase<SecuritySettings, NoParams> {
  const GetSecuritySettingsUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, SecuritySettings>> call(NoParams params) async {
    try {
      final SecuritySettings securitySettings = await _repository.getSecuritySettings();
      return Right(securitySettings);
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Failed to verify hardware availability: $e'),
      );
    }
  }
}
