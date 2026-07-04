import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/tables/accounts.dart';
import 'package:ledger_app/core/database/tables/categories.dart';

enum TransactionType { expense, income }

@DataClassName('TransactionModel')
class Transactions extends Table {
  TextColumn get id => text()();

  TextColumn get comment => text().nullable()();

  IntColumn get amount => integer()();

  IntColumn get timestamp => integer()();

  TextColumn get type => textEnum<TransactionType>()();

  TextColumn get accountId => text().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get categoryId => text().references(Categories, #id, onDelete: KeyAction.restrict)();

  @override
  Set<Column> get primaryKey => {id};
}
