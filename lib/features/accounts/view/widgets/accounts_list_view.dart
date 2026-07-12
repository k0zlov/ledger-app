import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/accounts/view/widgets/account_list_tile.dart';

class AccountsListView extends StatelessWidget {
  const AccountsListView({
    required this.accounts,
    required this.onAccountTap,
    this.description,
    super.key,
  });

  final List<Account> accounts;
  final void Function(Account) onAccountTap;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (accounts.isEmpty) {
      return Center(child: Text(l10n.noAccountsYet));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                description!,
                style: const TextStyle(color: CupertinoColors.systemGrey),
              ),
            ),
          CupertinoListSection.insetGrouped(
            children: accounts.map((account) {
              return AccountListTile(
                account: account,
                onTap: () => onAccountTap(account),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
