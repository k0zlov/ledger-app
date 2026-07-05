import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/domain/entities/category.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.type,
    required this.isTechnical,
  });

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      icon: entity.icon,
      type: entity.type,
      isTechnical: entity.isTechnical,
    );
  }

  final String id;
  final String name;
  final int color;
  final int icon;
  final CategoryType type;
  final bool isTechnical;

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      color: color,
      icon: icon,
      type: type,
      isTechnical: isTechnical,
    );
  }

  CategoriesCompanion toCompanion() {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      icon: Value(icon),
      type: Value(type),
      isTechnical: Value(isTechnical),
    );
  }
}
