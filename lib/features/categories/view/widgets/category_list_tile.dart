import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    required this.category,
    this.onTap,
    super.key,
  });

  final Category category;
  final VoidCallback? onTap;

  String _getLocalizedType(BuildContext context, CategoryType type) {
    final l10n = context.l10n;
    switch (type) {
      case CategoryType.expense:
        return l10n.categoryTypeExpense;
      case CategoryType.income:
        return l10n.categoryTypeIncome;
      case CategoryType.any:
        return l10n.categoryTypeAny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(category.name),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Color(category.color).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          IconData(
            // TODO(k0zlov): Resolve this issue
            // ignore: non_const_argument_for_const_parameter
            category.icon,
            fontFamily: CupertinoIcons.iconFont,
            fontPackage: CupertinoIcons.iconFontPackage,
          ),
          color: Color(category.color),
          size: 20,
        ),
      ),
      additionalInfo: Text(_getLocalizedType(context, category.type).toUpperCase()),
      onTap: onTap,
    );
  }
}
