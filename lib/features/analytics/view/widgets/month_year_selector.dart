import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class MonthYearSelector extends StatelessWidget {
  const MonthYearSelector({
    required this.currentDate,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime currentDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final monthYearLabel = DateFormat.yMMMM().format(currentDate);
    final now = DateTime.now();
    final isCurrentMonth = currentDate.year == now.year && currentDate.month == now.month;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onPrevious,
            child: const Icon(CupertinoIcons.chevron_left),
          ),
          Text(
            monthYearLabel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isCurrentMonth ? null : onNext,
            child: Icon(
              CupertinoIcons.chevron_right,
              color: isCurrentMonth
                  ? CupertinoColors.systemGrey4.resolveFrom(context)
                  : CupertinoTheme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
