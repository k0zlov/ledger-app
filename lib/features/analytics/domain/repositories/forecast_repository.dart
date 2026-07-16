import 'package:ledger_app/features/analytics/domain/entities/category_forecast.dart';

abstract interface class ForecastRepository {
  Future<List<CategoryForecast>> getCategoryForecasts({String? accountId});
}
