import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/account.dart';
import 'package:ledger_app/core/view/extensions/account_type_x.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class AccountFilterChips extends StatelessWidget {
  const AccountFilterChips({
    required this.accounts,
    required this.selectedAccountId,
    required this.onAccountSelected,
    super.key,
  });

  final List<Account> accounts;
  final String? selectedAccountId;
  final ValueChanged<String?> onAccountSelected;

  Widget _buildFilterChip(String label, IconData? icon, int? colorValue, bool isSelected, VoidCallback onTap) {
    final color = colorValue != null ? Color(colorValue) : CupertinoColors.activeBlue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? CupertinoColors.white : color,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? CupertinoColors.white : color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip(
            l10n.allAccounts,
            null,
            null,
            selectedAccountId == null,
            () => onAccountSelected(null),
          ),
          ...accounts.map(
            (account) => _buildFilterChip(
              account.name,
              account.type.icon,
              account.color,
              selectedAccountId == account.id,
              () => onAccountSelected(account.id),
            ),
          ),
        ],
      ),
    );
  }
}
