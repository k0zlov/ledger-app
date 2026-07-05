import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';

class AccountDialog extends StatefulWidget {
  const AccountDialog({
    required this.title,
    required this.onSave,
    this.onDelete,
    this.initialName,
    this.initialType,
    this.initialColor,
    super.key,
  });

  final String title;
  final void Function(String name, AccountType type, int color) onSave;
  final VoidCallback? onDelete;
  final String? initialName;
  final AccountType? initialType;
  final int? initialColor;

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  late final TextEditingController _nameController;
  late AccountType _selectedType;
  late int _selectedColor;

  static const List<int> _colors = [
    0xFF007AFF,
    0xFF34C759,
    0xFFFF9500,
    0xFFFF3B30,
    0xFFA2845E,
    0xFF5856D6,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedType = widget.initialType ?? AccountType.bank;
    _selectedColor = widget.initialColor ?? _colors.first;
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
              placeholder: l10n.accountNamePlaceholder,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            _AccountTypeSelector(
              selectedType: _selectedType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
            ),
            const SizedBox(height: 16),
            _AccountColorSelector(
              colors: _colors,
              selectedColor: _selectedColor,
              onColorChanged: (color) => setState(() => _selectedColor = color),
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
              widget.onSave(name, _selectedType, _selectedColor);
              context.navigator.pop();
            }
          },
          child: Text(l10n.saveButton),
        ),
      ],
    );
  }
}

class _AccountTypeSelector extends StatelessWidget {
  const _AccountTypeSelector({
    required this.selectedType,
    required this.onTypeChanged,
  });

  final AccountType selectedType;
  final ValueChanged<AccountType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<AccountType>(
        groupValue: selectedType,
        onValueChanged: (value) {
          if (value != null) onTypeChanged(value);
        },
        children: {
          AccountType.cash: Text(l10n.accountTypeCash, style: const TextStyle(fontSize: 12)),
          AccountType.bank: Text(l10n.accountTypeBank, style: const TextStyle(fontSize: 12)),
          AccountType.credit: Text(l10n.accountTypeCredit, style: const TextStyle(fontSize: 12)),
          AccountType.investment: Text(l10n.accountTypeInvestment, style: const TextStyle(fontSize: 12)),
        },
      ),
    );
  }
}

class _AccountColorSelector extends StatelessWidget {
  const _AccountColorSelector({
    required this.colors,
    required this.selectedColor,
    required this.onColorChanged,
  });

  final List<int> colors;
  final int selectedColor;
  final ValueChanged<int> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: colors.map((color) {
        final isSelected = selectedColor == color;
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: CupertinoColors.white, width: 2)
                  : Border.all(color: CupertinoColors.systemGrey4),
              boxShadow: isSelected
                  ? [BoxShadow(color: CupertinoColors.black.withValues(alpha: 0.3), blurRadius: 4)]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
