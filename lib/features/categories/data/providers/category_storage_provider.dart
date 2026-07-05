import 'package:ledger_app/core/data/models/category_model.dart';
import 'package:ledger_app/core/database/database.dart';

abstract interface class CategoryStorageProvider {
  Future<void> createCategory(CategoryModel category);

  Stream<List<CategoryModel>> watchCategories();

  Future<CategoryModel?> getCategoryById(String id);

  Future<void> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}

class CategoryStorageProviderImpl implements CategoryStorageProvider {
  const CategoryStorageProviderImpl({required this._db});

  final Database _db;

  @override
  Future<void> createCategory(CategoryModel category) async {
    await _db.into(_db.categories).insert(category.toCompanion());
  }

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return _db.select(_db.categories).watch().map((rows) {
      return rows
          .map(
            (row) => CategoryModel(
              id: row.id,
              name: row.name,
              color: row.color,
              icon: row.icon,
              type: row.type,
              isTechnical: row.isTechnical,
            ),
          )
          .toList();
    });
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) async {
    final row = await (_db.select(_db.categories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (row == null) return null;

    return CategoryModel(
      id: row.id,
      name: row.name,
      color: row.color,
      icon: row.icon,
      type: row.type,
      isTechnical: row.isTechnical,
    );
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _db.update(_db.categories).replace(category.toCompanion());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await (_db.delete(_db.categories)..where((tbl) => tbl.id.equals(id))).go();
  }
}
