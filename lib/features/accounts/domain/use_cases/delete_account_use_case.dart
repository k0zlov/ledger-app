import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/repositories/account_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class DeleteAccountParams {
  const DeleteAccountParams({required this.id});

  final String id;
}

class DeleteAccountUseCase implements UseCase<Unit, DeleteAccountParams> {
  const DeleteAccountUseCase({required this._repository});

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteAccountParams params) async {
    try {
      await _repository.deleteAccount(params.id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
