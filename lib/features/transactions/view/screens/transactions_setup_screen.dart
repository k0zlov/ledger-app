import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/currencies/currencies.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/core/view/extensions/account_type_x.dart';
import 'package:ledger_app/features/transactions/view/cubit/transactions_cubit.dart';

class TransactionsSetupScreen extends StatefulWidget {
  const TransactionsSetupScreen({
    required this.onSetupComplete,
    super.key,
  });

  final VoidCallback onSetupComplete;

  @override
  State<TransactionsSetupScreen> createState() => _TransactionsSetupScreenState();
}

class _TransactionsSetupScreenState extends State<TransactionsSetupScreen> {
  final Map<String, TextEditingController> _balanceControllers = {};

  @override
  void dispose() {
    for (final controller in _balanceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String accountId) {
    if (!_balanceControllers.containsKey(accountId)) {
      _balanceControllers[accountId] = TextEditingController();
    }
    return _balanceControllers[accountId]!;
  }

  Future<void> _saveInitialBalances(
    BuildContext context,
    List<Account> accounts,
    List<Category> categories,
  ) async {
    final l10n = context.l10n;
    final cubit = context.read<TransactionsCubit>();

    final initialBalanceCategory = categories.cast<Category?>().firstWhere(
      (c) => c?.isTechnical == true && c?.name == 'Initial Balance',
      orElse: () => categories.cast<Category?>().firstWhere(
        (c) => c?.isTechnical == true,
        orElse: () => categories.isNotEmpty ? categories.first : null,
      ),
    );

    if (initialBalanceCategory == null) {
      widget.onSetupComplete();
      return;
    }

    for (final account in accounts) {
      final text = _balanceControllers[account.id]?.text ?? '';
      final amount = int.tryParse(text) ?? 0;

      if (amount > 0) {
        await cubit.addTransaction(
          amount: amount,
          date: DateTime.now(),
          accountId: account.id,
          categoryId: initialBalanceCategory.id,
          note: l10n.initialBalanceNote,
        );
      }
    }

    widget.onSetupComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final accounts = context.select<TransactionsCubit, List<Account>>((c) => c.state.accounts);
    final categories = context.select<TransactionsCubit, List<Category>>((c) => c.state.categories);
    final currencyCode = context.select<SettingsCubit, String>((c) => c.state.appSettings.currency);

    final currencyInfo = currencies[currencyCode] ?? currencies['USD']!;

    final symbolSpacing = currencyInfo.spaceBetweenAmountAndSymbol ? 4.0 : 0.0;

    final prefix = currencyInfo.symbolOnLeft
        ? Padding(
            padding: EdgeInsets.only(left: 8, right: symbolSpacing),
            child: Text(
              currencyInfo.symbol,
              style: const TextStyle(color: CupertinoColors.systemGrey),
            ),
          )
        : null;

    final suffix = !currencyInfo.symbolOnLeft
        ? Padding(
            padding: EdgeInsets.only(right: 8, left: symbolSpacing),
            child: Text(
              currencyInfo.symbol,
              style: const TextStyle(color: CupertinoColors.systemGrey),
            ),
          )
        : null;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.initialBalancesTitle),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: accounts.isEmpty
                  ? Center(child: Text(l10n.noAccountsYet))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                            child: Text(
                              l10n.initialBalancesDescription,
                              style: const TextStyle(color: CupertinoColors.systemGrey),
                            ),
                          ),
                          CupertinoListSection.insetGrouped(
                            children: accounts.map((account) {
                              return CupertinoListTile(
                                title: Text(account.name),
                                leading: Icon(
                                  account.type.icon,
                                  color: Color(account.color),
                                ),
                                trailing: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 160,
                                    minWidth: 40,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IntrinsicWidth(
                                      child: CupertinoTextField(
                                        controller: _getController(account.id),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        placeholder: '0',
                                        textAlign: TextAlign.right,
                                        prefix: prefix,
                                        suffix: suffix,
                                        decoration: const BoxDecoration(
                                          color: CupertinoColors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: accounts.isEmpty ? null : () => _saveInitialBalances(context, accounts, categories),
                  child: Text(l10n.continueButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
