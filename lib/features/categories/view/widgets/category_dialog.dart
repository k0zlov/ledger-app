import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/enums/app_icon.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/extensions/app_icon_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({
    required this.title,
    required this.onSave,
    this.onDelete,
    this.initialName,
    this.initialType,
    this.initialColor,
    this.initialIcon,
    super.key,
  });

  final String title;
  final void Function(String name, CategoryType type, int color, AppIcon icon) onSave;
  final VoidCallback? onDelete;
  final String? initialName;
  final CategoryType? initialType;
  final int? initialColor;
  final AppIcon? initialIcon;

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  late final TextEditingController _nameController;
  late CategoryType _selectedType;
  late int _selectedColor;
  late AppIcon _selectedIcon;

  static const List<int> _colors = [
    0xFF007AFF,
    0xFF34C759,
    0xFFFF9500,
    0xFFFF3B30,
    0xFFA2845E,
    0xFF5856D6,
  ];

  static const List<AppIcon> _icons = [
    AppIcon.cart,
    AppIcon.house,
    AppIcon.car,
    AppIcon.gift,
    AppIcon.bag,
    AppIcon.flame,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedType = widget.initialType ?? CategoryType.expense;
    _selectedColor = widget.initialColor ?? _colors.first;
    _selectedIcon = widget.initialIcon ?? _icons.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.initialName != null;

    return CupertinoAlertDialog(
      title: Text(widget.title),
      content: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: _nameController,
              autofocus: true,
              placeholder: l10n.categoryNamePlaceholder,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<CategoryType>(
                groupValue: _selectedType,
                onValueChanged: (value) {
                  if (value != null) setState(() => _selectedType = value);
                },
                children: {
                  CategoryType.expense: Text(l10n.categoryTypeExpense, style: const TextStyle(fontSize: 12)),
                  CategoryType.income: Text(l10n.categoryTypeIncome, style: const TextStyle(fontSize: 12)),
                  CategoryType.any: Text(l10n.categoryTypeAny, style: const TextStyle(fontSize: 12)),
                },
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: CupertinoColors.white, width: 2)
                          : Border.all(color: CupertinoColors.systemGrey4),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _icons.map((appIcon) {
                final isSelected = _selectedIcon == appIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = appIcon),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? CupertinoColors.activeBlue.withValues(alpha: 0.2) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      appIcon.iconData,
                      color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey,
                      size: 20,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => context.navigator.pop(),
          child: Text(l10n.cancelButton),
        ),
        if (isEditing)
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              widget.onDelete?.call();
              context.navigator.pop();
            },
            child: Text(l10n.deleteButton),
          ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.length >= 2) {
              widget.onSave(name, _selectedType, _selectedColor, _selectedIcon);
              context.navigator.pop();
            }
          },
          child: Text(l10n.saveButton),
        ),
      ],
    );
  }
}
