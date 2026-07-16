import 'package:ledger_app/features/analytics/data/providers/forecast_provider.dart';
import 'package:ledger_app/features/analytics/domain/entities/category_forecast.dart';
import 'package:ledger_app/features/analytics/domain/repositories/forecast_repository.dart';
import 'package:ledger_app/features/categories/data/providers/category_storage_provider.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  const ForecastRepositoryImpl({
    required this._forecastProvider,
    required this._categoryProvider,
  });

  final ForecastProvider _forecastProvider;
  final CategoryStorageProvider _categoryProvider;

  @override
  Future<List<CategoryForecast>> getCategoryForecasts({String? accountId}) async {
    final categories = (await _categoryProvider.getAllCategories()).where((category) => !category.isTechnical).toList();
    final now = DateTime.now();

    final forecasts = <CategoryForecast>[];

    for (final category in categories) {
      final currentSpent = await _forecastProvider.getSpendForPeriod(
        categoryId: category.id,
        accountId: accountId,
        startDate: DateTime(now.year, now.month, 1),
        endDate: now,
      );

      final predictedSpend = await _forecastProvider.getCategoryPrediction(
        categoryId: category.id,
        accountId: accountId,
      );

      forecasts.add(
        CategoryForecast(
          categoryId: category.id,
          currentSpent: currentSpent,
          predictedSpend: predictedSpend,
        ),
      );
    }

    return forecasts;
  }
}
