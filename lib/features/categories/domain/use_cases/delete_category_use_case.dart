import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/repositories/category_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class DeleteCategoryUseCase implements UseCase<Unit, String> {
  const DeleteCategoryUseCase({required this._repository});

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    try {
      await _repository.deleteCategory(params);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not delete category'));
    }
  }
}
