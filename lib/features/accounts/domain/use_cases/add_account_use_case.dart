import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/repositories/account_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:uuid/uuid.dart';

class AddAccountParams {
  const AddAccountParams({
    required this.type,
    required this.color,
    required this.name,
  });

  final String name;
  final AccountType type;
  final int color;
}

class AddAccountUseCase implements UseCase<Unit, AddAccountParams> {
  const AddAccountUseCase({required this._repository});

  final AccountRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AddAccountParams params) async {
    final Account account = Account(
      id: const Uuid().v4(),
      name: params.name,
      balance: 0,
      type: params.type,
      color: params.color,
    );

    try {
      await _repository.createAccount(account);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
