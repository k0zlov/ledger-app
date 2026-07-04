part of 'accounts_cubit.dart';

@immutable
class AccountsState {
  const AccountsState({
    this.accounts = const <Account>[],
  });

  final List<Account> accounts;

  AccountsState copyWith({
    List<Account>? accounts,
  }) {
    return AccountsState(
      accounts: accounts ?? this.accounts,
    );
  }
}
