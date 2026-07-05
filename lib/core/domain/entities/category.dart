import 'package:flutter/cupertino.dart';

enum CategoryType {
  any,
  expense,
  income,
}

@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
  });

  final String id;
  final String name;
  final int color;
  final int icon;
  final CategoryType type;

  Category copyWith({
    String? id,
    String? name,
    int? color,
    int? icon,
    CategoryType? type,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color &&
          icon == other.icon &&
          type == other.type;

  @override
  int get hashCode => Object.hash(id, name, color, icon, type);
}
