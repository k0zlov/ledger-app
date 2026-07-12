import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/categories/view/cubit/categories_cubit.dart';
import 'package:ledger_app/features/categories/view/widgets/category_dialog.dart';

Future<void> showCategoryDialog(BuildContext context, [Category? category]) async {
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
