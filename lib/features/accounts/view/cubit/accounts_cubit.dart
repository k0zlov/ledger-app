import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/use_cases/watch_accounts_use_case.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/accounts/domain/use_cases/add_account_use_case.dart';
import 'package:ledger_app/features/accounts/domain/use_cases/delete_account_use_case.dart';
import 'package:ledger_app/features/accounts/domain/use_cases/update_account_use_case.dart';
import 'package:meta/meta.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  AccountsCubit({
    required this._addAccount,
    required this._watchAccounts,
    required this._deleteAccount,
    required this._updateAccount,
  }) : super(const AccountsState());

  final WatchAccountsUseCase _watchAccounts;
  final AddAccountUseCase _addAccount;
  final DeleteAccountUseCase _deleteAccount;
  final UpdateAccountUseCase _updateAccount;
  StreamSubscription<List<Account>>? _accountsSubscription;

  Future<void> initialize() async {
    final result = await _watchAccounts(NoParams());

    result.fold(
      (failure) {},
      (stream) {
        _accountsSubscription = stream.listen((accounts) => emit(state.copyWith(accounts: accounts)));
      },
    );
  }

  Future<void> addAccount({
    required String name,
    required int color,
    required AccountType type,
  }) async {
    final result = await _addAccount(AddAccountParams(name: name, type: type, color: color));

    result.fold((failure) {}, (_) {});
  }

  Future<void> deleteAccount(String id) async {
    final result = await _deleteAccount(DeleteAccountParams(id: id));

    result.fold((failure) {}, (_) {});
  }

  Future<void> updateAccount(Account account) async {
    final result = await _updateAccount(UpdateAccountParams(account: account));

    result.fold((failure) {}, (_) {});
  }

  @override
  Future<void> close() async {
    await _accountsSubscription?.cancel();
    return super.close();
  }
}
