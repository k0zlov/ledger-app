part of 'transactions_cubit.dart';

@immutable
class TransactionsState {
  const TransactionsState({
    this.transactions = const <Transaction>[],
    this.accounts = const <Account>[],
    this.categories = const <Category>[],
  });

  final List<Transaction> transactions;
  final List<Account> accounts;
  final List<Category> categories;

  TransactionsState copyWith({
    List<Transaction>? transactions,
    List<Account>? accounts,
    List<Category>? categories,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      accounts: accounts ?? this.accounts,
      categories: categories ?? this.categories,
    );
  }
}
