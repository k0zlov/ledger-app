import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/account_type_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/amount_text.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';

class AccountsListSection extends StatelessWidget {
  const AccountsListSection({
    required this.accounts,
    required this.getAccountBalance,
    super.key,
  });

  final List<Account> accounts;
  final int Function(Account account) getAccountBalance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListSection(
      title: l10n.accounts,
      children: accounts.map((account) {
        return _AccountListTile(
          account: account,
          getAccountBalance: getAccountBalance,
        );
      }).toList(),
    );
  }
}

class _AccountListTile extends StatelessWidget {
  const _AccountListTile({
    required this.getAccountBalance,
    required this.account,
  });

  final Account account;
  final int Function(Account account) getAccountBalance;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: Icon(account.type.icon, color: Color(account.color)),
      title: Text(account.name),
      additionalInfo: AmountText(
        amount: getAccountBalance(account),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: CupertinoColors.label,
        ),
      ),
    );
  }
}
