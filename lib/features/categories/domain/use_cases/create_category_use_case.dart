import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/repositories/category_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:uuid/uuid.dart';

class CreateCategoryParams {
  const CreateCategoryParams({
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
  });

  final String name;
  final int color;
  final int icon;
  final CategoryType type;
}

class CreateCategoryUseCase implements UseCase<Unit, CreateCategoryParams> {
  const CreateCategoryUseCase({required this._repository});

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CreateCategoryParams params) async {
    try {
      final category = Category(
        id: const Uuid().v4(),
        name: params.name,
        color: params.color,
        icon: params.icon,
        type: params.type,
      );

      await _repository.createCategory(category);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not create category'));
    }
  }
}
