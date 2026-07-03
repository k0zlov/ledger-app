import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class CheckBiometricAvailabilityUseCase implements UseCase<bool, NoParams> {
  const CheckBiometricAvailabilityUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final bool available = await _repository.checkBiometricsAvailability();
      return Right(available);
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Failed to verify hardware availability: $e'),
      );
    }
  }
}
