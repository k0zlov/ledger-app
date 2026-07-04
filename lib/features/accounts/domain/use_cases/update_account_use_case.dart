import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/repositories/account_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class UpdateAccountParams {
  const UpdateAccountParams({required this.account});

  final Account account;
}

class UpdateAccountUseCase implements UseCase<Unit, UpdateAccountParams> {
  const UpdateAccountUseCase({required this._repository});

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UpdateAccountParams params) async {
    try {
      await _repository.updateAccount(params.account);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
