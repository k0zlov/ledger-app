import 'package:ledger_app/core/domain/entities/account.dart';

abstract interface class AccountRepository {
  Future<void> createAccount(Account account);

  Stream<List<Account>> watchAccounts();

  Future<Account?> getAccountById(String id);

  Future<void> updateAccount(Account account);

  Future<void> deleteAccount(String id);
}
