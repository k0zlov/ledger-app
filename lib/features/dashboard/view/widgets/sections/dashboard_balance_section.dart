import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/animated_amount_text.dart';

class DashboardBalanceSection extends StatelessWidget {
  const DashboardBalanceSection({
    required this.totalBalance,
    required this.dateRangeLabel,
    required this.onDateRangeTap,
    super.key,
  });

  final int totalBalance;
  final String dateRangeLabel;
  final VoidCallback onDateRangeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.balance,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: onDateRangeTap,
                child: Row(
                  children: [
                    Text(
                      dateRangeLabel,
                      style: const TextStyle(
                        color: CupertinoColors.activeBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      CupertinoIcons.chevron_down,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedAmountText(
            amount: totalBalance,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
              color: CupertinoColors.label,
            ),
          ),
        ],
      ),
    );
  }
}
