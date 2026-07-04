import 'package:flutter/cupertino.dart';

enum AccountType { cash, bank, credit, investment }

@immutable
class Account {
  const Account({
    required this.type,
    required this.color,
    required this.balance,
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
  final int balance;
  final AccountType type;
  final int color;

  Account copyWith({
    String? id,
    String? name,
    int? balance,
    AccountType? type,
    int? color,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          balance == other.balance &&
          type == other.type &&
          color == other.color;

  @override
  int get hashCode => Object.hash(id, name, balance, type, color);
}
