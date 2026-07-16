import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/forecast/forecast_service.dart';

abstract interface class ForecastProvider {
  Future<double> getCategoryPrediction({
    required String categoryId,
    String? accountId,
  });

  Future<double> getSpendForPeriod({
    required String categoryId,
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
  });
}

class ForecastProviderImpl implements ForecastProvider {
  const ForecastProviderImpl({
    required this._forecastService,
    required this._db,
  });

  final Database _db;
  final ForecastService _forecastService;

  @override
  Future<double> getCategoryPrediction({
    required String categoryId,
    String? accountId,
  }) async {
    final now = DateTime.now();
    final currentDay = now.day;

    final currentSpent = await getSpendForPeriod(
      categoryId: categoryId,
      accountId: accountId,
      startDate: DateTime(now.year, now.month),
      endDate: now,
    );

    final lastMonthTotal = await getSpendForPeriod(
      categoryId: categoryId,
      accountId: accountId,
      startDate: DateTime(now.year, now.month - 1),
      endDate: DateTime(now.year, now.month, 0, 23, 59, 59),
    );

    final totalHistoricalSpend = await getSpendForPeriod(
      categoryId: categoryId,
      accountId: accountId,
      startDate: DateTime(now.year, now.month - 3),
      endDate: DateTime(now.year, now.month, 0, 23, 59, 59),
    );

    final threeMonthAverage = totalHistoricalSpend / 3;

    double historicalPartialSpend = 0;
    for (int i = 1; i <= 3; i++) {
      historicalPartialSpend += await getSpendForPeriod(
        categoryId: categoryId,
        accountId: accountId,
        startDate: DateTime(now.year, now.month - i),
        endDate: DateTime(now.year, now.month - i, currentDay, 23, 59, 59),
      );
    }

    double personalRatio = 1;

    if (totalHistoricalSpend > 0) {
      personalRatio = historicalPartialSpend / totalHistoricalSpend;
    } else {
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      personalRatio = currentDay / daysInMonth;
    }

    return _forecastService.predictExpense(
      dayOfMonth: currentDay,
      currentSpent: currentSpent,
      lastMonthTotal: lastMonthTotal,
      threeMonthAverage: threeMonthAverage,
      personalRatio: personalRatio,
    );
  }

  @override
  Future<double> getSpendForPeriod({
    required String categoryId,
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
  }) async {
    final query = _db.select(_db.transactions)
      ..where((t) {
        var predicate =
            t.categoryId.equals(categoryId) &
            t.timestamp.isBetweenValues(
              startDate.millisecondsSinceEpoch,
              endDate.millisecondsSinceEpoch,
            );

        if (accountId != null) {
          predicate = predicate & t.accountId.equals(accountId);
        }

        return predicate;
      });

    final results = await query.get();

    return results.fold<double>(0, (sum, row) => sum + row.amount.toDouble());
  }
}
