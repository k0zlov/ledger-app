import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';

final class NoParams {}

abstract class UseCase<ReturnT, Params> {
  Future<Either<Failure, ReturnT>> call(Params params);
}
