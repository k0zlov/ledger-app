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

class TransactionCreationSheet extends StatefulWidget {
  const TransactionCreationSheet({
    required this.categories,
    required this.accounts,
    required this.onSave,
    this.selectedAccountId,
    super.key,
  });

  final List<Category> categories;
  final List<Account> accounts;
  final ValueChanged<Transaction> onSave;
  final String? selectedAccountId;

  @override
  State<TransactionCreationSheet> createState() => _TransactionCreationSheetState();
}

class _TransactionCreationSheetState extends State<TransactionCreationSheet> {
  late DateTime _date;
  String? _accountId;
  String? _categoryId;

  late TextEditingController _noteController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _accountId = widget.selectedAccountId;
    _categoryId = null;

    _noteController = TextEditingController();
    _amountController = TextEditingController(text: '0');

    _amountController.addListener(_onFormUpdated);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onFormUpdated);
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onFormUpdated() {
    setState(() {});
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
      _date = newDate;
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
              initialDateTime: _date,
              onDateTimeChanged: _handleDateChanged,
            ),
          ),
        );
      },
    );
  }

  void _handleAccountSelected(int index, List<Account?> items) {
    setState(() {
      _accountId = items[index]?.id;
    });
  }

  void _handleAccountTap() {
    final items = [null, ...widget.accounts];
    final initialIndex = _accountId == null ? 0 : items.indexWhere((a) => a?.id == _accountId);

    unawaited(
      _handleShowPicker<Account?>(
        items: items,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
        itemBuilder: (account) {
          if (account == null) {
            return Center(
              child: Text(
                context.l10n.selectAccount,
                style: const TextStyle(fontSize: 20, color: CupertinoColors.systemGrey),
              ),
            );
          }
          return _AccountPickerItem(account: account);
        },
        onSelectedItemChanged: (index) => _handleAccountSelected(index, items),
      ),
    );
  }

  void _handleCategorySelected(int index, List<Category?> items) {
    setState(() {
      _categoryId = items[index]?.id;
    });
  }

  void _handleCategoryTap() {
    final items = [null, ...widget.categories];
    final initialIndex = _categoryId == null ? 0 : items.indexWhere((c) => c?.id == _categoryId);

    unawaited(
      _handleShowPicker<Category?>(
        items: items,
        initialIndex: initialIndex >= 0 ? initialIndex : 0,
        itemBuilder: (cat) {
          if (cat == null) {
            return Center(
              child: Text(
                context.l10n.selectCategory,
                style: const TextStyle(fontSize: 20, color: CupertinoColors.systemGrey),
              ),
            );
          }
          return _CategoryPickerItem(category: cat);
        },
        onSelectedItemChanged: (index) => _handleCategorySelected(index, items),
      ),
    );
  }

  void _handleCancelTap() {
    context.navigator.pop();
  }

  void _handleSaveTap() {
    final parsedAmount = int.tryParse(_amountController.text.trim()) ?? 0;

    if (parsedAmount == 0 || _accountId == null || _categoryId == null) {
      return;
    }

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: parsedAmount.abs(),
      date: _date,
      accountId: _accountId!,
      categoryId: _categoryId!,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    widget.onSave(newTransaction);
    context.navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final parsedAmount = int.tryParse(_amountController.text.trim()) ?? 0;

    final isFormValid = parsedAmount != 0 && _accountId != null && _categoryId != null;

    final currentCategory = widget.categories.cast<Category?>().firstWhere(
      (c) => c?.id == _categoryId,
      orElse: () => null,
    );

    final currentAccount = widget.accounts.cast<Account?>().firstWhere(
      (a) => a?.id == _accountId,
      orElse: () => null,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            ModalNavigationBar(
              title: l10n.newTransaction,
              leftText: l10n.cancelButton,
              rightText: l10n.addButton,
              onLeftTap: _handleCancelTap,
              onRightTap: isFormValid ? _handleSaveTap : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    TransactionAmountSection(
                      isEditing: true,
                      amount: parsedAmount,
                      controller: _amountController,
                      categoryType: currentCategory?.type ?? CategoryType.any,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentCategory?.name ?? l10n.selectCategory,
                      style: const TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TransactionInfoSection(
                      isEditing: true,
                      categoryType: currentCategory?.type ?? CategoryType.any,
                      dateText: _formatDateTime(_date),
                      accountName: currentAccount?.name ?? l10n.selectAccount,
                      accountIcon: currentAccount?.type.icon ?? CupertinoIcons.creditcard,
                      accountColor: currentAccount != null ? Color(currentAccount.color) : CupertinoColors.systemGrey,
                      categoryName: currentCategory?.name ?? l10n.selectCategory,
                      categoryIcon: currentCategory?.icon,
                      categoryColor: currentCategory != null
                          ? Color(currentCategory.color)
                          : CupertinoColors.systemGrey,
                      onDateTap: _handleShowDatePicker,
                      onAccountTap: _handleAccountTap,
                      onCategoryTap: _handleCategoryTap,
                    ),
                    TransactionNoteSection(
                      isEditing: true,
                      noteController: _noteController,
                    ),
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
