import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/categories/view/cubit/categories_cubit.dart';
import 'package:ledger_app/features/categories/view/utils/show_category_dialog.dart';
import 'package:ledger_app/features/categories/view/widgets/categories_list_view.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = context.select<CategoriesCubit, List<Category>>(
      (c) => c.state.categories.where((cat) => !cat.isTechnical).toList(),
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.categories),
        previousPageTitle: l10n.backButton,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => showCategoryDialog(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: CategoriesListView(
          categories: categories,
          onCategoryTap: (category) => showCategoryDialog(context, category),
        ),
      ),
    );
  }
}
