import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/repositories/account_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class WatchAccountsUseCase implements UseCase<Stream<List<Account>>, NoParams> {
  const WatchAccountsUseCase({required this._repository});

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Stream<List<Account>>>> call(NoParams params) async {
    try {
      return Right(_repository.watchAccounts());
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
