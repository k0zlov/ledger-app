import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/accounts/view/utils/show_account_dialog.dart';
import 'package:ledger_app/features/accounts/view/widgets/accounts_list_view.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accounts = context.select<AccountsCubit, List<Account>>((c) => c.state.accounts);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.accounts),
        previousPageTitle: l10n.settings,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => showAccountDialog(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: AccountsListView(
          accounts: accounts,
          onAccountTap: (account) => showAccountDialog(context, account),
        ),
      ),
    );
  }
}
