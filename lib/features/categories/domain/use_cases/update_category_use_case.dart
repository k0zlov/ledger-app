import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/repositories/category_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class UpdateCategoryUseCase implements UseCase<Unit, Category> {
  const UpdateCategoryUseCase({required this._repository});

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(Category params) async {
    try {
      await _repository.updateCategory(params);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not update category'));
    }
  }
}
