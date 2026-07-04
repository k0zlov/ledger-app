import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';

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

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(account.name),
      leading: Icon(
        _icon,
        color: Color(account.color),
      ),
      additionalInfo: Text(account.type.name.toUpperCase()),
      onTap: onTap,
    );
  }
}