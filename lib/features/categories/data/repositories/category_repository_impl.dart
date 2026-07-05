import 'package:ledger_app/core/data/models/category_model.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/repositories/category_repository.dart';
import 'package:ledger_app/features/categories/data/providers/category_storage_provider.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({required this._storageProvider});

  final CategoryStorageProvider _storageProvider;

  @override
  Future<void> createCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await _storageProvider.createCategory(model);
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _storageProvider.watchCategories().map((models) {
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final model = await _storageProvider.getCategoryById(id);
    return model?.toEntity();
  }

  @override
  Future<void> updateCategory(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await _storageProvider.updateCategory(model);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _storageProvider.deleteCategory(id);
  }
}
