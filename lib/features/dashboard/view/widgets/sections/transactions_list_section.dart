import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/entities/transaction.dart';
import 'package:ledger_app/core/view/extensions/app_icon_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/amount_text.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';

class TransactionsListSection extends StatelessWidget {
  const TransactionsListSection({
    required this.transactions,
    required this.onTransactionTap,
    super.key,
  });

  final List<Transaction> transactions;
  final ValueChanged<Transaction> onTransactionTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sortedTransactions = List<Transaction>.from(transactions)..sort((a, b) => b.date.compareTo(a.date));

    return ListSection(
      title: l10n.recentTransactions,
      children: [
        if (sortedTransactions.isEmpty) const _NoTransactionsListTile(),

        if (sortedTransactions.isNotEmpty)
          ...sortedTransactions.map((transaction) {
            return _TransactionListTile(
              transaction: transaction,
              onTap: onTransactionTap,
            );
          }),
      ],
    );
  }
}

class _NoTransactionsListTile extends StatelessWidget {
  const _NoTransactionsListTile();

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Center(
        child: Text(
          context.l10n.noTransactionsYet,
          style: const TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
    );
  }
}

class _TransactionListTile extends StatelessWidget {
  const _TransactionListTile({
    required this.transaction,
    required this.onTap,
  });

  final ValueChanged<Transaction> onTap;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final Category? category = transaction.category;
    final isExpense = category?.type == CategoryType.expense;

    return CupertinoListTile(
      onTap: () => onTap(transaction),
      leading: Icon(
        transaction.category?.icon.iconData ?? CupertinoIcons.question,
        color: Color(category?.color ?? CupertinoColors.systemGrey.toARGB32()),
      ),
      title: Text(category?.name ?? l10n.unknown),
      subtitle: transaction.note != null && transaction.note!.isNotEmpty ? Text(transaction.note!) : null,
      additionalInfo: AmountText(
        amount: isExpense ? -transaction.amount : transaction.amount,
        showSign: true,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
