import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class EnableBiometricsUseCase implements UseCase<bool, String> {
  const EnableBiometricsUseCase({required this._repository});

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String reason) async {
    try {
      final bool authenticated = await _repository.enableBiometrics(reason);
      return Right(authenticated);
    } catch (e) {
      return Left(
        CacheFailure(errorMessage: 'Native biometric prompt failed: $e'),
      );
    }
  }
}
