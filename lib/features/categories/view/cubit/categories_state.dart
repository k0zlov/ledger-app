part of 'categories_cubit.dart';

@immutable
class CategoriesState {
  const CategoriesState({
    this.categories = const <Category>[],
  });

  final List<Category> categories;

  CategoriesState copyWith({
    List<Category>? categories,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
    );
  }
}