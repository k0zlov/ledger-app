class CategoryForecast {
  const CategoryForecast({
    required this.categoryId,
    required this.currentSpent,
    required this.predictedSpend,
  });

  final String categoryId;
  final double currentSpent;
  final double predictedSpend;

  CategoryForecast copyWith({
    String? categoryId,
    double? currentSpent,
    double? predictedSpend,
  }) {
    return CategoryForecast(
      categoryId: categoryId ?? this.categoryId,
      currentSpent: currentSpent ?? this.currentSpent,
      predictedSpend: predictedSpend ?? this.predictedSpend,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryForecast &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          currentSpent == other.currentSpent &&
          predictedSpend == other.predictedSpend;

  @override
  int get hashCode => Object.hash(categoryId, currentSpent, predictedSpend);
}
