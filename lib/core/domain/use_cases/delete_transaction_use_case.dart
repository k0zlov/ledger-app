import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/repositories/transaction_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class DeleteTransactionUseCase implements UseCase<Unit, String> {
  const DeleteTransactionUseCase({required this._repository});

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    try {
      await _repository.deleteTransaction(params);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not delete transaction'));
    }
  }
}
