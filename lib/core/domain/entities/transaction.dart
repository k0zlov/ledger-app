import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/entities/category.dart';

@immutable
class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.accountId,
    required this.categoryId,
    this.note,
    this.account,
    this.category,
  });

  final String id;
  final int amount;
  final DateTime date;
  final String accountId;
  final String categoryId;
  final String? note;
  final Account? account;
  final Category? category;

  Transaction copyWith({
    String? id,
    int? amount,
    DateTime? date,
    String? accountId,
    String? categoryId,
    String? note,
    Account? account,
    Category? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      account: account ?? this.account,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          date == other.date &&
          accountId == other.accountId &&
          categoryId == other.categoryId &&
          note == other.note &&
          account == other.account &&
          category == other.category;

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    date,
    accountId,
    categoryId,
    note,
    account,
    category,
  );
}
