import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/repositories/category_repository.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';

class WatchCategoriesUseCase implements UseCase<Stream<List<Category>>, NoParams> {
  const WatchCategoriesUseCase({required this._repository});

  final CategoryRepository _repository;

  @override
  Future<Either<Failure, Stream<List<Category>>>> call(NoParams params) async {
    try {
      final stream = _repository.watchCategories();
      return Right(stream);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not watch categories'));
    }
  }
}
