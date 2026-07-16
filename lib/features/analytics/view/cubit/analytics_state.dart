part of 'analytics_cubit.dart';

@immutable
class AnalyticsState {
  const AnalyticsState({
    this.isLoading = false,
    this.accounts = const [],
    this.categories = const [],
    this.transactions = const [],
    this.forecasts = const [],
  });

  final List<Account> accounts;
  final List<Category> categories;
  final List<Transaction> transactions;
  final List<CategoryForecast> forecasts;
  final bool isLoading;

  AnalyticsState copyWith({
    List<Account>? accounts,
    List<Category>? categories,
    List<Transaction>? transactions,
    List<CategoryForecast>? forecasts,
    bool? isLoading,
  }) {
    return AnalyticsState(
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      forecasts: forecasts ?? this.forecasts,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
