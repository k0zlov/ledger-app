import 'package:ledger_app/core/data/models/account_model.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/repositories/account_repository.dart';
import 'package:ledger_app/features/accounts/data/providers/account_storage_provider.dart';

class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl({required this._storageProvider});

  final AccountStorageProvider _storageProvider;

  @override
  Future<void> createAccount(Account account) async {
    final model = AccountModel.fromEntity(account);
    await _storageProvider.createAccount(model);
  }

  @override
  Stream<List<Account>> watchAccounts() {
    return _storageProvider.watchAccounts().map((models) {
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Account?> getAccountById(String id) async {
    final model = await _storageProvider.getAccountById(id);
    return model?.toEntity();
  }

  @override
  Future<void> updateAccount(Account account) async {
    final model = AccountModel.fromEntity(account);
    await _storageProvider.updateAccount(model);
  }

  @override
  Future<void> deleteAccount(String id) async {
    await _storageProvider.deleteAccount(id);
  }
}
