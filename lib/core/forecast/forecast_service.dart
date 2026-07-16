import 'package:flutter_litert/flutter_litert.dart';

abstract interface class ForecastService {
  double predictExpense({
    required int dayOfMonth,
    required double currentSpent,
    required double lastMonthTotal,
    required double threeMonthAverage,
    required double personalRatio,
  });
}

class ForecastServiceMl implements ForecastService {
  const ForecastServiceMl({required this._interpreter});

  final Interpreter _interpreter;

  @override
  double predictExpense({
    required int dayOfMonth,
    required double currentSpent,
    required double lastMonthTotal,
    required double threeMonthAverage,
    required double personalRatio,
  }) {
    final input = [
      [
        dayOfMonth.toDouble(),
        currentSpent,
        lastMonthTotal,
        threeMonthAverage,
        personalRatio,
      ],
    ];

    final output = List<double>.filled(1, 0).reshape<double>([1, 1]);

    _interpreter.run(input, output);

    final result = output[0][0] as double?;

    if (result == null) return currentSpent;

    return result > 0 ? result : currentSpent;
  }
}
