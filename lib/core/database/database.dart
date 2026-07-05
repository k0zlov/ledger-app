import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ledger_app/core/database/default_data/default_categories.dart';
import 'package:ledger_app/core/database/tables/accounts.dart';
import 'package:ledger_app/core/database/tables/categories.dart';
import 'package:ledger_app/core/database/tables/transactions.dart';
import 'package:ledger_app/core/database/views/account_balances_view.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Accounts, Categories, Transactions],
  views: [AccountBalancesView],
)
class Database extends _$Database {
  Database([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();

        await batch((batch) {
          batch.insertAll(categories, getDefaultCategories());
        });
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'ledger.db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
