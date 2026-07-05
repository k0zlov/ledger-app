import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/repositories/transaction_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:uuid/uuid.dart';

class CreateTransactionParams {
  const CreateTransactionParams({
    required this.amount,
    required this.date,
    required this.accountId,
    required this.categoryId,
    this.note,
  });

  final int amount;
  final DateTime date;
  final String accountId;
  final String categoryId;
  final String? note;
}

class CreateTransactionUseCase implements UseCase<Unit, CreateTransactionParams> {
  const CreateTransactionUseCase({required this._repository});

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CreateTransactionParams params) async {
    try {
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: params.amount,
        date: params.date,
        accountId: params.accountId,
        categoryId: params.categoryId,
        note: params.note,
      );

      await _repository.createTransaction(transaction);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not create transaction'));
    }
  }
}
