import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/repositories/transaction_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class UpdateTransactionUseCase implements UseCase<Unit, Transaction> {
  const UpdateTransactionUseCase({required this._repository});

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Transaction params) async {
    try {
      await _repository.updateTransaction(params);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not update transaction'));
    }
  }
}
