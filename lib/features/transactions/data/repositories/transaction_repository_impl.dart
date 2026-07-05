import 'package:ledger_app/core/data/models/transaction_model.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/domain/repositories/transaction_repository.dart';
import 'package:ledger_app/features/transactions/data/providers/transaction_storage_provider.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl({required this._storageProvider});

  final TransactionStorageProvider _storageProvider;

  @override
  Future<void> createTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await _storageProvider.createTransaction(model);
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return _storageProvider.watchTransactions().map((models) {
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final model = await _storageProvider.getTransactionById(id);
    return model?.toEntity();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    await _storageProvider.updateTransaction(model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _storageProvider.deleteTransaction(id);
  }
}
