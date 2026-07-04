import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/tables/accounts.dart';
import 'package:ledger_app/core/database/tables/transactions.dart';

abstract class AccountBalancesView extends View {
  Accounts get accounts;

  Transactions get transactions;

  Expression<int> get balance => coalesce([transactions.amount.sum(), const Constant(0)]);

  @override
  Query<HasResultSet, dynamic> as() =>
      select([
          accounts.id,
          accounts.name,
          accounts.type,
          accounts.color,
          balance,
        ]).from(accounts).join([leftOuterJoin(transactions, transactions.accountId.equalsExp(accounts.id))])
        ..groupBy([accounts.id]);
}
