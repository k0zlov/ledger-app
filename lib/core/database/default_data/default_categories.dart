import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:uuid/uuid.dart';

List<CategoriesCompanion> getDefaultCategories() {
  const uuid = Uuid();

  return [
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Groceries',
      type: CategoryType.expense,
      color: 0xFF34C759,
      icon: 0xf3f2,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Salary',
      type: CategoryType.income,
      color: 0xFF007AFF,
      icon: 0xf3f0,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Rent',
      type: CategoryType.expense,
      color: 0xFFFF9500,
      icon: 0xf447,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Transportation',
      type: CategoryType.expense,
      color: 0xFF5856D6,
      icon: 0xf3d2,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Initial Balance',
      type: CategoryType.any,
      color: 0xFF8E8E93,
      icon: 0xf3e5,
      isTechnical: const Value(true),
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Adjustment',
      type: CategoryType.any,
      color: 0xFF8E8E93,
      icon: 0xf4c1,
      isTechnical: const Value(true),
    ),
  ];
}
