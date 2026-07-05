import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/repositories/auth_repository.dart';

class AuthenticateWithPinUseCase implements UseCase<bool, String> {
  const AuthenticateWithPinUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(String params) async {
    try {
      final isSuccess = await repository.authenticateWithPin(params);
      return Right(isSuccess);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Failed to authenticate with PIN'));
    }
  }
}
