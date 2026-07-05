import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/use_cases/watch_categories_use_case.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/categories/domain/use_cases/create_category_use_case.dart';
import 'package:ledger_app/features/categories/domain/use_cases/delete_category_use_case.dart';
import 'package:ledger_app/features/categories/domain/use_cases/update_category_use_case.dart';
import 'package:meta/meta.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required this._watchCategories,
    required this._createCategory,
    required this._deleteCategory,
    required this._updateCategory,
  }) : super(const CategoriesState());

  final WatchCategoriesUseCase _watchCategories;
  final CreateCategoryUseCase _createCategory;
  final DeleteCategoryUseCase _deleteCategory;
  final UpdateCategoryUseCase _updateCategory;
  StreamSubscription<List<Category>>? _categoriesSubscription;

  Future<void> initialize() async {
    final result = await _watchCategories(NoParams());

    result.fold(
      (failure) {},
      (stream) {
        _categoriesSubscription = stream.listen((categories) => emit(state.copyWith(categories: categories)));
      },
    );
  }

  Future<void> addCategory({
    required String name,
    required int color,
    required int icon,
    required CategoryType type,
  }) async {
    final result = await _createCategory(
      CreateCategoryParams(
        name: name,
        color: color,
        icon: icon,
        type: type,
      ),
    );

    result.fold((failure) {}, (_) {});
  }

  Future<void> deleteCategory(String id) async {
    final result = await _deleteCategory(id);

    result.fold((failure) {}, (_) {});
  }

  Future<void> updateCategory(Category category) async {
    final result = await _updateCategory(category);

    result.fold((failure) {}, (_) {});
  }

  @override
  Future<void> close() async {
    await _categoriesSubscription?.cancel();
    return super.close();
  }
}
