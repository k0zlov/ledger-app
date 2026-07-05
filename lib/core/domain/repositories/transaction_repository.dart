import 'package:ledger_app/core/domain/entities/transaction.dart';

abstract interface class TransactionRepository {
  Future<void> createTransaction(Transaction transaction);

  Stream<List<Transaction>> watchTransactions();

  Future<Transaction?> getTransactionById(String id);

  Future<void> updateTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);
}
