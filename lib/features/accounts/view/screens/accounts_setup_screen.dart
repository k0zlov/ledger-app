import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/accounts/view/utils/show_account_dialog.dart';
import 'package:ledger_app/features/accounts/view/widgets/accounts_list_view.dart';

class AccountsSetupScreen extends StatelessWidget {
  const AccountsSetupScreen({
    required this.onSetupComplete,
    super.key,
  });

  final VoidCallback onSetupComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accounts = context.select<AccountsCubit, List<Account>>((c) => c.state.accounts);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.accountsSetupTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => showAccountDialog(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AccountsListView(
                accounts: accounts,
                onAccountTap: (account) => showAccountDialog(context, account),
                description: l10n.accountsSetupDescription,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  onPressed: accounts.isEmpty ? null : onSetupComplete,
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
