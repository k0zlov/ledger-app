part of 'dashboard_cubit.dart';

@immutable
class DashboardState {
  const DashboardState({
    this.accounts = const [],
    this.transactions = const [],
    this.categories = const [],
  });

  final List<Account> accounts;
  final List<Transaction> transactions;
  final List<Category> categories;

  DashboardState copyWith({
    List<Account>? accounts,
    List<Transaction>? transactions,
    List<Category>? categories,
  }) {
    return DashboardState(
      accounts: accounts ?? this.accounts,
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
    );
  }
}
