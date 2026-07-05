import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';

extension AccountTypeX on AccountType {
  IconData get icon {
    switch (this) {
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
}
