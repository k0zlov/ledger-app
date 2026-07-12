import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/categories/view/widgets/category_list_tile.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({
    required this.categories,
    required this.onCategoryTap,
    this.description,
    super.key,
  });

  final List<Category> categories;
  final void Function(Category) onCategoryTap;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (categories.isEmpty) {
      return Center(child: Text(l10n.noCategoriesYet));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                description!,
                style: const TextStyle(color: CupertinoColors.systemGrey),
              ),
            ),
          CupertinoListSection.insetGrouped(
            children: categories.map((category) {
              return CategoryListTile(
                category: category,
                onTap: () => onCategoryTap(category),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
