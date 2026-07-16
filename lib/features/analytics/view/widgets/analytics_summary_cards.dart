import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/widgets/animated_amount_text.dart';

class AnalyticsSummaryCards extends StatelessWidget {
  const AnalyticsSummaryCards({
    required this.income,
    required this.outcome,
    this.predicted,
    super.key,
  });

  final int income;
  final int outcome;
  final int? predicted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'Income',
            amount: income,
            color: CupertinoColors.activeGreen,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SummaryCard(
            title: 'Spent',
            amount: outcome,
            color: CupertinoColors.destructiveRed,
          ),
        ),
        if (predicted != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: SummaryCard(
              title: 'Prediction',
              amount: predicted!,
              color: CupertinoColors.activeOrange,
            ),
          ),
        ],
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    super.key,
  });

  final String title;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedAmountText(
            amount: amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
