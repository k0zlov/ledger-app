import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/database/tables/categories.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/localization/generated/app_localizations.dart';
import 'package:ledger_app/core/view/extensions/app_icon_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class TransactionInfoSection extends StatelessWidget {
  const TransactionInfoSection({
    required this.isEditing,
    required this.categoryType,
    required this.dateText,
    required this.accountName,
    required this.accountIcon,
    required this.accountColor,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.onDateTap,
    required this.onAccountTap,
    required this.onCategoryTap,
    super.key,
  });

  final bool isEditing;
  final CategoryType categoryType;
  final String dateText;
  final String accountName;
  final IconData accountIcon;
  final Color accountColor;
  final String categoryName;
  final AppIcon? categoryIcon;
  final Color categoryColor;
  final VoidCallback onDateTap;
  final VoidCallback onAccountTap;
  final VoidCallback onCategoryTap;

  String _typeText(AppLocalizations l10n) {
    switch (categoryType) {
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
    final l10n = context.l10n;

    return CupertinoListSection.insetGrouped(
      children: [
        CupertinoListTile(
          title: Text(l10n.type),
          additionalInfo: Text(_typeText(l10n)),
        ),
        CupertinoListTile(
          title: Text(l10n.date),
          additionalInfo: Text(
            dateText,
            style: TextStyle(color: isEditing ? CupertinoColors.activeBlue : CupertinoColors.label),
          ),
          trailing: isEditing ? const CupertinoListTileChevron() : null,
          onTap: isEditing ? onDateTap : null,
        ),
        CupertinoListTile(
          title: Text(l10n.accounts),
          additionalInfo: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(accountIcon, size: 16, color: accountColor),
              const SizedBox(width: 6),
              Text(
                accountName,
                style: TextStyle(color: isEditing ? CupertinoColors.activeBlue : CupertinoColors.label),
              ),
            ],
          ),
          trailing: isEditing ? const CupertinoListTileChevron() : null,
          onTap: isEditing ? onAccountTap : null,
        ),
        CupertinoListTile(
          title: Text(l10n.category),
          additionalInfo: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(categoryIcon?.iconData ?? CupertinoIcons.square_grid_2x2, size: 16, color: categoryColor),
              const SizedBox(width: 6),
              Text(
                categoryName,
                style: TextStyle(color: isEditing ? CupertinoColors.activeBlue : CupertinoColors.label),
              ),
            ],
          ),
          trailing: isEditing ? const CupertinoListTileChevron() : null,
          onTap: isEditing ? onCategoryTap : null,
        ),
      ],
    );
  }
}
