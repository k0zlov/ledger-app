import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';

final class NoParams {}

abstract interface class UseCase<ReturnT, Params> {
  const UseCase();

  Future<Either<Failure, ReturnT>> call(Params params);
}
