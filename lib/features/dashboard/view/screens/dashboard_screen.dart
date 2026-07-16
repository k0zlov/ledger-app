import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/dashboard/view/cubit/dashboard_cubit.dart';
import 'package:ledger_app/core/view/widgets/account_filter_chips.dart';
import 'package:ledger_app/features/dashboard/view/widgets/modals/date_range_picker_sheet.dart';
import 'package:ledger_app/features/dashboard/view/widgets/modals/transaction_creation_sheet.dart';
import 'package:ledger_app/features/dashboard/view/widgets/modals/transaction_details_sheet.dart';
import 'package:ledger_app/features/dashboard/view/widgets/sections/accounts_list_section.dart';
import 'package:ledger_app/features/dashboard/view/widgets/sections/dashboard_balance_section.dart';
import 'package:ledger_app/features/dashboard/view/widgets/sections/transactions_list_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedAccountId;
  DateTime? _startDate;
  DateTime? _endDate;

  String _formatDateString(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$m/$d/$y';
  }

  bool _isTransactionInTimeFrame(Transaction tx) {
    if (_startDate == null || _endDate == null) return true;
    final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);

    return tx.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
        tx.date.isBefore(end.add(const Duration(seconds: 1)));
  }

  Future<void> _handleDateRangeSelection() async {
    await showCupertinoModalPopup<(DateTime?, DateTime?)?>(
      context: context,
      builder: (context) => DateRangePickerSheet(
        start: _startDate,
        end: _endDate,
        onChanged: (start, end) {
          setState(() {
            _startDate = start;
            _endDate = end;
          });
        },
      ),
    );
  }

  void _handleAccountSelected(String? id) {
    setState(() {
      _selectedAccountId = id;
    });
  }

  void _handleTransactionTap(Transaction tx) {
    final DashboardCubit cubit = context.read();
    final DashboardState state = cubit.state;

    unawaited(
      showCupertinoModalPopup<void>(
        context: context,
        builder: (sheetContext) => TransactionDetailsSheet(
          transaction: tx,
          categories: state.categories,
          accounts: state.accounts,
          onSave: (updatedTx) {
            unawaited(cubit.updateTransaction(updatedTx));
          },
          onDelete: (txToDelete) {
            unawaited(cubit.deleteTransaction(txToDelete.id));
            sheetContext.navigator.pop();
          },
        ),
      ),
    );
  }

  void _handleCreateTransaction() {
    final DashboardCubit cubit = context.read();
    final DashboardState state = cubit.state;

    final availableCategories = state.categories.where((c) => c.name != 'Initial Balance').toList();

    if (state.accounts.isEmpty || availableCategories.isEmpty) return;

    unawaited(
      showCupertinoModalPopup<void>(
        context: context,
        builder: (sheetContext) => TransactionCreationSheet(
          categories: availableCategories,
          accounts: state.accounts,
          selectedAccountId: _selectedAccountId,
          onSave: (newTx) {
            unawaited(
              cubit.addTransaction(
                amount: newTx.amount,
                date: newTx.date,
                accountId: newTx.accountId,
                categoryId: newTx.categoryId,
                note: newTx.note,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final DashboardState state = context.select<DashboardCubit, DashboardState>((c) => c.state);

    Category? getCategory(String categoryId) {
      return state.categories.cast<Category?>().firstWhere(
        (c) => c?.id == categoryId,
        orElse: () => null,
      );
    }

    int getAccountBalance(Account account) {
      return state.transactions.where((tx) => tx.accountId == account.id && _isTransactionInTimeFrame(tx)).fold<int>(
        0,
        (sum, tx) {
          final cat = getCategory(tx.categoryId);
          return cat?.type == CategoryType.expense ? sum - tx.amount : sum + tx.amount;
        },
      );
    }

    final filteredTransactions = state.transactions.where((tx) {
      if (tx.category?.isTechnical ?? false) return false;

      if (_selectedAccountId != null && tx.accountId != _selectedAccountId) {
        return false;
      }
      return _isTransactionInTimeFrame(tx);
    }).toList();

    final totalBalance = state.transactions.fold<int>(0, (sum, tx) {
      final category = getCategory(tx.categoryId);
      if (category?.type == CategoryType.expense) {
        return sum - tx.amount;
      }
      return sum + tx.amount;
    });

    final dateRangeLabel = (_startDate != null && _endDate != null)
        ? '${_formatDateString(_startDate!)} - ${_formatDateString(_endDate!)}'
        : l10n.allTime;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(l10n.dashboard),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _handleCreateTransaction,
              child: const Icon(CupertinoIcons.add_circled),
            ),
          ),
          SliverToBoxAdapter(
            child: DashboardBalanceSection(
              totalBalance: totalBalance,
              dateRangeLabel: dateRangeLabel,
              onDateRangeTap: _handleDateRangeSelection,
            ),
          ),
          if (state.accounts.isNotEmpty)
            SliverToBoxAdapter(
              child: AccountFilterChips(
                accounts: state.accounts,
                selectedAccountId: _selectedAccountId,
                onAccountSelected: _handleAccountSelected,
              ),
            ),
          if (state.accounts.isNotEmpty && _selectedAccountId == null)
            SliverToBoxAdapter(
              child: AccountsListSection(
                accounts: state.accounts.take(3).toList(),
                getAccountBalance: getAccountBalance,
              ),
            ),
          SliverToBoxAdapter(
            child: TransactionsListSection(
              transactions: filteredTransactions.take(10).toList(),
              onTransactionTap: _handleTransactionTap,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
