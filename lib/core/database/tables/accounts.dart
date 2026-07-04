import 'package:drift/drift.dart';
import 'package:ledger_app/core/domain/entities/account.dart';

export 'package:ledger_app/core/domain/entities/account.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get type => textEnum<AccountType>()();

  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
