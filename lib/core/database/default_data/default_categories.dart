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
      // Green
      icon: 0xf3f2, // CupertinoIcons.cart_fill codePoint
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Salary',
      type: CategoryType.income,
      color: 0xFF007AFF,
      // Blue
      icon: 0xf3f0, // CupertinoIcons.briefcase_fill codePoint
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Rent',
      type: CategoryType.expense,
      color: 0xFFFF9500,
      // Orange
      icon: 0xf447, // CupertinoIcons.house_fill codePoint
    ),
    CategoriesCompanion.insert(
      id: uuid.v4(),
      name: 'Transportation',
      type: CategoryType.expense,
      color: 0xFF5856D6,
      // Purple
      icon: 0xf3d2, // CupertinoIcons.car_detailed codePoint
    ),
  ];
}
