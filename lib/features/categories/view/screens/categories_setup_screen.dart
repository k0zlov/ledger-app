import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/features/categories/view/cubit/categories_cubit.dart';
import 'package:ledger_app/features/categories/view/widgets/category_dialog.dart';
import 'package:ledger_app/features/categories/view/widgets/category_list_tile.dart';

class CategoriesSetupScreen extends StatelessWidget {
  const CategoriesSetupScreen({
    required this.onSetupComplete,
    super.key,
  });

  final VoidCallback onSetupComplete;

  Future<void> _showCategoryDialog(BuildContext context, [Category? category]) async {
    final l10n = context.l10n;
    final isEditing = category != null;

    final cubit = context.read<CategoriesCubit>();

    await showCupertinoDialog<void>(
      context: context,
      builder: (_) => CategoryDialog(
        title: isEditing ? l10n.editCategoryTitle : l10n.addCategoryTitle,
        initialName: category?.name,
        initialType: category?.type,
        initialColor: category?.color,
        initialIcon: category?.icon,
        onSave: (name, type, color, icon) async {
          if (isEditing) {
            await cubit.updateCategory(
              category.copyWith(
                name: name,
                type: type,
                color: color,
                icon: icon,
              ),
            );
          } else {
            await cubit.addCategory(
              name: name,
              type: type,
              color: color,
              icon: icon,
            );
          }
        },
        onDelete: isEditing ? () async => cubit.deleteCategory(category.id) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = context.select<CategoriesCubit, List<Category>>((c) => c.state.categories);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.categoriesSetupTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showCategoryDialog(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: categories.isEmpty
                  ? Center(child: Text(l10n.noCategoriesYet))
                  : SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        children: categories.map((category) {
                          return CategoryListTile(
                            category: category,
                            onTap: () => _showCategoryDialog(context, category),
                          );
                        }).toList(),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: categories.isEmpty ? null : onSetupComplete,
                  child: Text(l10n.continueButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
