import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class CheckPinUseCase implements UseCase<bool, String> {
  const CheckPinUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String pin) async {
    try {
      final isValid = await _repository.checkPin(pin);
      return Right(isValid);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
