import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    required this.account,
    this.onTap,
    super.key,
  });

  final Account account;
  final VoidCallback? onTap;

  IconData get _icon {
    switch (account.type) {
      case AccountType.cash:
        return CupertinoIcons.money_dollar;
      case AccountType.bank:
        return CupertinoIcons.building_2_fill;
      case AccountType.credit:
        return CupertinoIcons.creditcard_fill;
      case AccountType.investment:
        return CupertinoIcons.chart_pie_fill;
    }
  }

  String _getLocalizedType(BuildContext context, AccountType type) {
    final l10n = context.l10n;
    switch (type) {
      case AccountType.cash:
        return l10n.accountTypeCash;
      case AccountType.bank:
        return l10n.accountTypeBank;
      case AccountType.credit:
        return l10n.accountTypeCredit;
      case AccountType.investment:
        return l10n.accountTypeInvestment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(account.name),
      leading: Icon(
        _icon,
        color: Color(account.color),
      ),
      additionalInfo: Text(_getLocalizedType(context, account.type).toUpperCase()),
      onTap: onTap,
    );
  }
}
