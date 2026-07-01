import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class CheckBiometricsAvailabilityUseCase implements UseCase<bool, NoParams> {
  const CheckBiometricsAvailabilityUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final bool isAvailable = await _repository.checkBiometricsAvailability();
      return Right(isAvailable);
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Failed to verify hardware availability: $e'),
      );
    }
  }
}
