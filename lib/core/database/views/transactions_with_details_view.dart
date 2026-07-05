import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/tables/accounts.dart';
import 'package:ledger_app/core/database/tables/categories.dart';
import 'package:ledger_app/core/database/tables/transactions.dart';

abstract class TransactionsWithDetailsView extends View {
  Transactions get transactions;

  Accounts get accounts;

  Categories get categories;

  Expression<String> get accountName => accounts.name;

  Expression<int> get accountColor => accounts.color;

  Expression<String> get accountType => accounts.type;

  Expression<String> get categoryName => categories.name;

  Expression<int> get categoryColor => categories.color;

  Expression<int> get categoryIcon => categories.icon;

  Expression<String> get categoryType => categories.type;

  Expression<bool> get categoryIsTechnical => categories.isTechnical;

  @override
  Query<HasResultSet, dynamic> as() =>
      select([
        transactions.id,
        transactions.amount,
        transactions.timestamp,
        transactions.note,
        transactions.accountId,
        transactions.categoryId,
        accountName,
        accountColor,
        accountType,
        categoryName,
        categoryColor,
        categoryIcon,
        categoryType,
        categoryIsTechnical,
      ]).from(transactions).join([
        innerJoin(accounts, accounts.id.equalsExp(transactions.accountId)),
        innerJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      ]);
}
