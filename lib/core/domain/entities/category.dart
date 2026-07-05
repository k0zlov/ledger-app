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
    this.isTechnical = false,
  });

  final String id;
  final String name;
  final int color;
  final int icon;
  final CategoryType type;
  final bool isTechnical;

  Category copyWith({
    String? id,
    String? name,
    int? color,
    int? icon,
    CategoryType? type,
    bool? isTechnical,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isTechnical: isTechnical ?? this.isTechnical,
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
          type == other.type &&
          isTechnical == other.isTechnical;

  @override
  int get hashCode => Object.hash(id, name, color, icon, type, isTechnical);
}
