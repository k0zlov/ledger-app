import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/view/extensions/app_icon_x.dart';
import 'package:ledger_app/core/view/widgets/amount_text.dart';

class CategoryRowData {
  const CategoryRowData({
    required this.category,
    required this.currentSpent,
    this.predictedSpend,
  });

  final Category category;
  final double currentSpent;
  final double? predictedSpend;
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    required this.rows,
    required this.showPredictions,
    super.key,
  });

  final List<CategoryRowData> rows;
  final bool showPredictions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          return CategoryTile(
            data: rows[index],
            showPrediction: showPredictions,
          );
        }),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    required this.data,
    required this.showPrediction,
    super.key,
  });

  final CategoryRowData data;
  final bool showPrediction;

  @override
  Widget build(BuildContext context) {
    final categoryColor = Color(data.category.color);
    final hasPrediction = showPrediction && data.predictedSpend != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  data.category.icon.iconData,
                  color: categoryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data.category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              if (hasPrediction)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AmountText(
                      amount: data.currentSpent.round(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                    Text(
                      ' / ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    AmountText(
                      amount: data.predictedSpend!.round(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                  ],
                )
              else
                AmountText(
                  amount: data.currentSpent.round(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
            ],
          ),
          if (hasPrediction) ...[
            const SizedBox(height: 12),
            CupertinoProgressBar(
              progress: _calculateProgress(data.currentSpent, data.predictedSpend!),
              color: data.currentSpent >= data.predictedSpend!
                  ? CupertinoColors.destructiveRed
                  : CupertinoTheme.of(context).primaryColor,
            ),
          ],
        ],
      ),
    );
  }

  double _calculateProgress(double current, double predicted) {
    final safePredicted = predicted > 0 ? predicted : 1.0;
    return (current / safePredicted).clamp(0.0, 1.0);
  }
}

class CupertinoProgressBar extends StatelessWidget {
  const CupertinoProgressBar({
    required this.progress,
    required this.color,
    super.key,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
