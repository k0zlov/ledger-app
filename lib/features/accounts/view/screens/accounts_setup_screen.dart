import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/accounts/view/widgets/account_dialog.dart';
import 'package:ledger_app/features/accounts/view/widgets/account_list_tile.dart';

class AccountsSetupScreen extends StatelessWidget {
  const AccountsSetupScreen({
    required this.onSetupComplete,
    super.key,
  });

  final VoidCallback onSetupComplete;

  Future<void> _showAccountDialog(BuildContext context, [Account? account]) async {
    final l10n = context.l10n;
    final isEditing = account != null;

    final cubit = context.read<AccountsCubit>();

    await showCupertinoDialog<void>(
      context: context,
      builder: (_) => AccountDialog(
        title: isEditing ? l10n.editAccountTitle : l10n.addAccountTitle,
        initialName: account?.name,
        initialType: account?.type,
        initialColor: account?.color,
        onSave: (name, type, color) async {
          if (isEditing) {
            await cubit.updateAccount(
              account.copyWith(
                name: name,
                type: type,
                color: color,
              ),
            );
          } else {
            await cubit.addAccount(
              name: name,
              type: type,
              color: color,
            );
          }
        },
        onDelete: isEditing ? () async => cubit.deleteAccount(account.id) : null,
      ),
    );
  }

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
          onPressed: () => _showAccountDialog(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: accounts.isEmpty
                  ? Center(child: Text(l10n.noAccountsYet))
                  : SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        children: accounts.map((account) {
                          return AccountListTile(
                            account: account,
                            onTap: () => _showAccountDialog(context, account),
                          );
                        }).toList(),
                      ),
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
