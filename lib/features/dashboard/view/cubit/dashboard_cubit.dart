import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/database/tables/accounts.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/use_cases/create_transaction_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/delete_transaction_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/update_transaction_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_accounts_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_categories_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_transactions_use_case.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:meta/meta.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required CreateTransactionUseCase createTransaction,
    required DeleteTransactionUseCase deleteTransaction,
    required UpdateTransactionUseCase updateTransaction,
    required WatchTransactionsUseCase watchTransactions,
    required WatchAccountsUseCase watchAccounts,
    required WatchCategoriesUseCase watchCategories,
  }) : _createTransaction = createTransaction,
       _deleteTransaction = deleteTransaction,
       _updateTransaction = updateTransaction,
       _watchTransactions = watchTransactions,
       _watchAccounts = watchAccounts,
       _watchCategories = watchCategories,
       super(const DashboardState());

  final WatchTransactionsUseCase _watchTransactions;
  final WatchAccountsUseCase _watchAccounts;
  final WatchCategoriesUseCase _watchCategories;

  final CreateTransactionUseCase _createTransaction;
  final DeleteTransactionUseCase _deleteTransaction;
  final UpdateTransactionUseCase _updateTransaction;

  StreamSubscription<List<Transaction>>? _transactionsSub;
  StreamSubscription<List<Account>>? _accountsSub;
  StreamSubscription<List<Category>>? _categoriesSub;

  Future<void> initialize() async {
    final txResult = await _watchTransactions(NoParams());
    txResult.fold(
      (f) {},
      (stream) => _transactionsSub = stream.listen((t) => emit(state.copyWith(transactions: t))),
    );

    final accResult = await _watchAccounts(NoParams());
    accResult.fold(
      (f) {},
      (stream) => _accountsSub = stream.listen((a) => emit(state.copyWith(accounts: a))),
    );

    final catResult = await _watchCategories(NoParams());
    catResult.fold(
      (f) {},
      (stream) => _categoriesSub = stream.listen((c) => emit(state.copyWith(categories: c))),
    );
  }

  Future<void> addTransaction({
    required double amount,
    required DateTime date,
    required String accountId,
    required String categoryId,
    String? note,
  }) async {
    await _createTransaction(
      CreateTransactionParams(
        amount: amount,
        date: date,
        accountId: accountId,
        categoryId: categoryId,
        note: note,
      ),
    );
  }

  Future<void> createTransaction({
    required double amount,
    required DateTime date,
    required String accountId,
    required String categoryId,
    String? note,
  }) async {
    final params = CreateTransactionParams(
      amount: amount,
      date: date,
      accountId: accountId,
      categoryId: categoryId,
      note: note,
    );

    final result = await _createTransaction(params);

    result.fold(
      (failure) {},
      (_) {},
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final result = await _updateTransaction(transaction);

    result.fold(
      (failure) {},
      (_) {},
    );
  }

  Future<void> deleteTransaction(String id) async {
    final result = await _deleteTransaction(id);

    result.fold(
      (failure) {},
      (_) {},
    );
  }

  @override
  Future<void> close() async {
    await _transactionsSub?.cancel();
    await _accountsSub?.cancel();
    await _categoriesSub?.cancel();
    return super.close();
  }
}
