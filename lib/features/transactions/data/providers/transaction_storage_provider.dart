import 'package:ledger_app/core/data/models/account_model.dart';
import 'package:ledger_app/core/data/models/category_model.dart';
import 'package:ledger_app/core/data/models/transaction_model.dart';
import 'package:ledger_app/core/database/database.dart';

abstract interface class TransactionStorageProvider {
  Future<void> createTransaction(TransactionModel transaction);

  Stream<List<TransactionModel>> watchTransactions();

  Future<TransactionModel?> getTransactionById(String id);

  Future<void> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);
}

class TransactionStorageProviderImpl implements TransactionStorageProvider {
  const TransactionStorageProviderImpl({required this._db});

  final Database _db;

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    await _db.into(_db.transactions).insert(transaction.toCompanion());
  }

  @override
  Stream<List<TransactionModel>> watchTransactions() {
    return _db.select(_db.transactionsWithDetailsView).watch().map((rows) {
      return rows.map((row) {
        return TransactionModel(
          id: row.id,
          amount: row.amount,
          date: DateTime.fromMillisecondsSinceEpoch(row.timestamp),
          accountId: row.accountId,
          categoryId: row.categoryId,
          note: row.note,
          account: AccountModel(
            id: row.accountId,
            name: row.accountName,
            color: row.accountColor,
            type: row.accountType,
            balance: 0,
          ),
          category: CategoryModel(
            id: row.categoryId,
            name: row.categoryName,
            color: row.categoryColor,
            icon: row.categoryIcon,
            type: row.categoryType,
            isTechnical: row.categoryIsTechnical,
          ),
        );
      }).toList();
    });
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    final row = await (_db.select(
      _db.transactionsWithDetailsView,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (row == null) return null;

    return TransactionModel(
      id: row.id,
      amount: row.amount,
      date: DateTime.fromMillisecondsSinceEpoch(row.timestamp),
      accountId: row.accountId,
      categoryId: row.categoryId,
      note: row.note,
      account: AccountModel(
        id: row.accountId,
        name: row.accountName,
        color: row.accountColor,
        type: row.accountType,
        balance: 0,
      ),
      category: CategoryModel(
        id: row.categoryId,
        name: row.categoryName,
        color: row.categoryColor,
        icon: row.categoryIcon,
        type: row.categoryType,
        isTechnical: row.categoryIsTechnical,
      ),
    );
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _db.update(_db.transactions).replace(transaction.toCompanion());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await (_db.delete(_db.transactions)..where((tbl) => tbl.id.equals(id))).go();
  }
}
