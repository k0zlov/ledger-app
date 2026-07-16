import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/use_cases/watch_accounts_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_categories_use_case.dart';
import 'package:ledger_app/core/domain/use_cases/watch_transactions_use_case.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/analytics/domain/entities/category_forecast.dart';
import 'package:ledger_app/features/analytics/domain/use_cases/get_categories_forecast.dart';
import 'package:meta/meta.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit({
    required this._watchTransactions,
    required this._watchAccounts,
    required this._watchCategories,
    required this._getCategoryForecasts,
  }) : super(const AnalyticsState());

  final WatchTransactionsUseCase _watchTransactions;
  final WatchAccountsUseCase _watchAccounts;
  final WatchCategoriesUseCase _watchCategories;
  final GetCategoryForecasts _getCategoryForecasts;

  StreamSubscription<List<Transaction>>? _transactionsSub;
  StreamSubscription<List<Account>>? _accountsSub;
  StreamSubscription<List<Category>>? _categoriesSub;

  Future<void> initialize() async {
    final txResult = await _watchTransactions(NoParams());
    txResult.fold(
      (f) {},
      (stream) => _transactionsSub = stream.listen((t) {
        emit(state.copyWith(transactions: t));
        unawaited(loadForecasts());
      }),
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

    await loadForecasts();
  }

  Future<void> loadForecasts({String? accountId}) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getCategoryForecasts(accountId);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
      },
      (forecasts) {
        emit(
          state.copyWith(
            forecasts: forecasts,
            isLoading: false,
          ),
        );
      },
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
