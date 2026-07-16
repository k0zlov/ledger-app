import 'package:drift/drift.dart';
import 'package:ledger_app/core/data/models/account_model.dart';
import 'package:ledger_app/core/data/models/category_model.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.accountId,
    required this.categoryId,
    this.note,
    this.account,
    this.category,
  });

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: (entity.amount * 100).round(),
      date: entity.date,
      accountId: entity.accountId,
      categoryId: entity.categoryId,
      note: entity.note,
      account: entity.account != null ? AccountModel.fromEntity(entity.account!) : null,
      category: entity.category != null ? CategoryModel.fromEntity(entity.category!) : null,
    );
  }

  final String id;
  final int amount;
  final DateTime date;
  final String accountId;
  final String categoryId;
  final String? note;
  final AccountModel? account;
  final CategoryModel? category;

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount / 100,
      date: date,
      accountId: accountId,
      categoryId: categoryId,
      note: note,
      account: account?.toEntity(),
      category: category?.toEntity(),
    );
  }

  TransactionsCompanion toCompanion() {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      timestamp: Value(date.millisecondsSinceEpoch),
      accountId: Value(accountId),
      categoryId: Value(categoryId),
      note: Value(note),
    );
  }
}
