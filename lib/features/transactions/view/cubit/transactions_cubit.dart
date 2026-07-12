import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/use_cases/create_transaction_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_accounts_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_categories_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_transactions_use_case.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:meta/meta.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit({
    required this._watchTransactions,
    required this._watchAccounts,
    required this._watchCategories,
    required this._createTransaction,
  }) : super(const TransactionsState());

  final WatchTransactionsUseCase _watchTransactions;
  final WatchAccountsUseCase _watchAccounts;
  final WatchCategoriesUseCase _watchCategories;
  final CreateTransactionUseCase _createTransaction;

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
    required int amount,
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

  @override
  Future<void> close() async {
    await _transactionsSub?.cancel();
    await _accountsSub?.cancel();
    await _categoriesSub?.cancel();
    return super.close();
  }
}
