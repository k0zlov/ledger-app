import 'package:ledger_app/core/data/models/account_model.dart';
import 'package:ledger_app/core/database/database.dart';

abstract interface class AccountStorageProvider {
  Future<void> createAccount(AccountModel account);

  Stream<List<AccountModel>> watchAccounts();

  Future<AccountModel?> getAccountById(String id);

  Future<void> updateAccount(AccountModel account);

  Future<void> deleteAccount(String id);
}

class AccountStorageProviderImpl implements AccountStorageProvider {
  const AccountStorageProviderImpl({required this._db});

  final Database _db;

  @override
  Future<void> createAccount(AccountModel account) async {
    await _db.into(_db.accounts).insert(account.toCompanion());
  }

  @override
  Stream<List<AccountModel>> watchAccounts() {
    return _db.select(_db.accountBalancesView).watch().map((rows) {
      return rows
          .map(
            (row) => AccountModel(
              id: row.id,
              name: row.name,
              balance: row.balance ?? 0,
              type: row.type,
              color: row.color,
            ),
          )
          .toList();
    });
  }

  @override
  Future<AccountModel?> getAccountById(String id) async {
    final row = await (_db.select(_db.accountBalancesView)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (row == null) return null;

    return AccountModel(
      id: row.id,
      name: row.name,
      balance: row.balance ?? 0,
      type: row.type,
      color: row.color,
    );
  }

  @override
  Future<void> updateAccount(AccountModel account) async {
    await _db.update(_db.accounts).replace(account.toCompanion());
  }

  @override
  Future<void> deleteAccount(String id) async {
    await (_db.delete(_db.accounts)..where((tbl) => tbl.id.equals(id))).go();
  }
}
