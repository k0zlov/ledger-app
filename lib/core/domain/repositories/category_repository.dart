import 'package:ledger_app/core/domain/entities/category.dart';

abstract interface class CategoryRepository {
  Future<void> createCategory(Category category);

  Stream<List<Category>> watchCategories();

  Future<Category?> getCategoryById(String id);

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(String id);
}
