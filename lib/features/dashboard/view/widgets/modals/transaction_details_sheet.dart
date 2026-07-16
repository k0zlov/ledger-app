import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/extensions/account_type_x.dart';
import 'package:ledger_app/core/view/extensions/app_icon_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/dashboard/view/widgets/navigation_bar/modal_navigation_bar.dart';
import 'package:ledger_app/features/dashboard/view/widgets/sections/transaction_amount_section.dart';
import 'package:ledger_app/features/dashboard/view/widgets/sections/transaction_info_section.dart';
import 'package:ledger_app/features/dashboard/view/widgets/sections/transaction_note_section.dart';

class TransactionDetailsSheet extends StatefulWidget {
  const TransactionDetailsSheet({
    required this.categories,
    required this.accounts,
    required this.onSave,
    required this.onDelete,
    required this.transaction,
    super.key,
  });

  final Transaction transaction;
  final List<Category> categories;
  final List<Account> accounts;

  final ValueChanged<Transaction> onSave;
  final ValueChanged<Transaction> onDelete;

  @override
  State<TransactionDetailsSheet> createState() => _TransactionDetailsSheetState();
}

class _TransactionDetailsSheetState extends State<TransactionDetailsSheet> {
  bool _isEditing = false;
  late Transaction _currentTransaction;

  late TextEditingController _noteController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _currentTransaction = widget.transaction.copyWith();
    _noteController = TextEditingController(text: _currentTransaction.note ?? '');
    _amountController = TextEditingController(text: _currentTransaction.amount.toString());
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final y = date.year.toString();
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '$m/$d/$y $hh:$mm';
  }

  Future<void> _handleShowPicker<T>({
    required List<T> items,
    required int initialIndex,
    required Widget Function(T) itemBuilder,
    required ValueChanged<int> onSelectedItemChanged,
  }) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground,
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              itemExtent: 36,
              scrollController: FixedExtentScrollController(initialItem: initialIndex),
              onSelectedItemChanged: onSelectedItemChanged,
              children: items.map(itemBuilder).toList(),
            ),
          ),
        );
      },
    );
  }

  void _handleDateChanged(DateTime newDate) {
    setState(() {
      _currentTransaction = _currentTransaction.copyWith(date: newDate);
    });
  }

  Future<void> _handleShowDatePicker() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground,
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: _currentTransaction.date,
              onDateTimeChanged: _handleDateChanged,
            ),
          ),
        );
      },
    );
  }

  void _handleAccountSelected(int index) {
    setState(() {
      _currentTransaction = _currentTransaction.copyWith(
        accountId: widget.accounts[index].id,
      );
    });
  }

  void _handleAccountTap() {
    final initialIndex = widget.accounts.indexWhere((a) => a.id == _currentTransaction.accountId);
    unawaited(
      _handleShowPicker<Account>(
        items: widget.accounts,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
        itemBuilder: (account) => _AccountPickerItem(account: account),
        onSelectedItemChanged: _handleAccountSelected,
      ),
    );
  }

  void _handleCategorySelected(int index) {
    setState(() {
      _currentTransaction = _currentTransaction.copyWith(
        categoryId: widget.categories[index].id,
      );
    });
  }

  void _handleCategoryTap() {
    final initialIndex = widget.categories.indexWhere(
      (c) => c.id == _currentTransaction.categoryId,
    );
    unawaited(
      _handleShowPicker<Category>(
        items: widget.categories,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
        itemBuilder: (cat) => _CategoryPickerItem(category: cat),
        onSelectedItemChanged: _handleCategorySelected,
      ),
    );
  }

  void _handleLeftTap() {
    if (_isEditing) {
      setState(() {
        _isEditing = false;
        _currentTransaction = widget.transaction.copyWith();
        _noteController.text = _currentTransaction.note ?? '';
        _amountController.text = _currentTransaction.amount.toString();
      });
    } else {
      setState(() => _isEditing = true);
    }
  }

  void _handleRightTap() {
    if (_isEditing) {
      final parsedAmount = double.tryParse(_amountController.text.trim()) ?? _currentTransaction.amount;
      _currentTransaction = _currentTransaction.copyWith(
        amount: parsedAmount,
        note: _noteController.text.trim(),
      );
      widget.onSave(_currentTransaction);
      setState(() {
        _isEditing = false;
      });
    } else {
      context.navigator.pop();
    }
  }

  void _handleDelete() {
    widget.onDelete(widget.transaction);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final currentCategory = widget.categories.firstWhere(
      (c) => c.id == _currentTransaction.categoryId,
      orElse: () => widget.categories.first,
    );
    final currentAccount = widget.accounts.firstWhere(
      (a) => a.id == _currentTransaction.accountId,
      orElse: () => widget.accounts.first,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            ModalNavigationBar(
              title: l10n.transactionDetails,
              leftText: _isEditing ? l10n.cancelButton : l10n.editButton,
              rightText: _isEditing ? l10n.saveButton : l10n.doneButton,
              onLeftTap: _handleLeftTap,
              onRightTap: _handleRightTap,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    TransactionAmountSection(
                      isEditing: _isEditing,
                      amount: _currentTransaction.amount,
                      controller: _amountController,
                      categoryType: currentCategory.type,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentCategory.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TransactionInfoSection(
                      isEditing: _isEditing,
                      categoryType: currentCategory.type,
                      dateText: _formatDateTime(_currentTransaction.date),
                      accountName: currentAccount.name,
                      accountIcon: currentAccount.type.icon,
                      accountColor: Color(currentAccount.color),
                      categoryName: currentCategory.name,
                      categoryIcon: currentCategory.icon,
                      categoryColor: Color(currentCategory.color),
                      onDateTap: _handleShowDatePicker,
                      onAccountTap: _handleAccountTap,
                      onCategoryTap: _handleCategoryTap,
                    ),
                    TransactionNoteSection(
                      isEditing: _isEditing,
                      noteController: _noteController,
                    ),
                    if (!_isEditing) ...[
                      const SizedBox(height: 16),
                      CupertinoButton(
                        onPressed: _handleDelete,
                        child: const Text(
                          'Delete Transaction',
                          style: TextStyle(color: CupertinoColors.destructiveRed),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountPickerItem extends StatelessWidget {
  const _AccountPickerItem({
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(account.type.icon, size: 20, color: Color(account.color)),
        const SizedBox(width: 8),
        Text(
          account.name,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

class _CategoryPickerItem extends StatelessWidget {
  const _CategoryPickerItem({
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          category.icon.iconData,
          size: 20,
          color: Color(category.color),
        ),
        const SizedBox(width: 8),
        Text(
          category.name,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
