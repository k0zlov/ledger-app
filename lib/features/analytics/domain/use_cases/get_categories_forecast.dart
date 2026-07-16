import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/analytics/domain/entities/category_forecast.dart';
import 'package:ledger_app/features/analytics/domain/repositories/forecast_repository.dart';

class GetCategoryForecasts implements UseCase<List<CategoryForecast>, String?> {
  const GetCategoryForecasts({required this._repository});

  final ForecastRepository _repository;

  @override
  Future<Either<Failure, List<CategoryForecast>>> call(String? params) async {
    try {
      final forecasts = await _repository.getCategoryForecasts(accountId: params);

      return Right(forecasts);
    } catch (e) {
      return Left(CacheFailure(errorMessage: e.toString()));
    }
  }
}
