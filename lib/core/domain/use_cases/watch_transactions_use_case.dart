import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/repositories/transaction_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class WatchTransactionsUseCase implements UseCase<Stream<List<Transaction>>, NoParams> {
  const WatchTransactionsUseCase({required this._repository});

  final TransactionRepository _repository;

  @override
  Future<Either<Failure, Stream<List<Transaction>>>> call(NoParams params) async {
    try {
      final stream = _repository.watchTransactions();
      return Right(stream);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not watch transactions'));
    }
  }
}
