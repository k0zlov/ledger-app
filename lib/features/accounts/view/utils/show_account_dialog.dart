import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/accounts/view/cubit/accounts_cubit.dart';
import 'package:ledger_app/features/accounts/view/widgets/account_dialog.dart';

Future<void> showAccountDialog(BuildContext context, [Account? account]) async {
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
