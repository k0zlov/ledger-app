import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/domain/entities/account.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    required this.color,
  });

  factory AccountModel.fromEntity(Account entity) {
    return AccountModel(
      id: entity.id,
      name: entity.name,
      balance: entity.balance,
      type: entity.type,
      color: entity.color,
    );
  }

  final String id;
  final String name;
  final int balance;
  final AccountType type;
  final int color;

  Account toEntity() {
    return Account(
      id: id,
      name: name,
      balance: balance,
      type: type,
      color: color,
    );
  }

  AccountsCompanion toCompanion() {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      color: Value(color),
    );
  }
}
