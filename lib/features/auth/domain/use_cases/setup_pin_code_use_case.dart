import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class SetupPinCodeUseCase implements UseCase<Unit, String> {
  const SetupPinCodeUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String pin) async {
    if (pin.length < 4) {
      return const Left(
        CacheFailure(errorMessage: 'PIN must be at least 4 digits long'),
      );
    }

    try {
      await _repository.setupPinCode(pin);
      return const Right(unit);
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Failed to securely save PIN: $e'),
      );
    }
  }
}
