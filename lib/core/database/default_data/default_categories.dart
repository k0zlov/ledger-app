import 'package:drift/drift.dart';
import 'package:ledger_app/core/database/database.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/enums/app_icon.dart';

import 'package:uuid/uuid.dart';

List<CategoriesCompanion> getDefaultCategories() {
  const uuid = Uuid();

  return [
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Groceries',
      type: CategoryType.expense,
      color: 0xFF34C759,
      icon: AppIcon.cart,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Salary',
      type: CategoryType.income,
      color: 0xFF007AFF,
      icon: AppIcon.money,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Rent',
      type: CategoryType.expense,
      color: 0xFFFF9500,
      icon: AppIcon.house,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Transportation',
      type: CategoryType.expense,
      color: 0xFF5856D6,
      icon: AppIcon.car,
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Initial Balance',
      type: CategoryType.any,
      color: 0xFF8E8E93,
      icon: AppIcon.creditCard,
      isTechnical: const Value(true),
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Adjustment',
      type: CategoryType.any,
      color: 0xFF8E8E93,
      icon: AppIcon.wrench,
      isTechnical: const Value(true),
    ),
  ];
}
