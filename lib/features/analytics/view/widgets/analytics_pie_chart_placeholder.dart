import 'package:flutter/cupertino.dart';

class AnalyticsPieChartPlaceholder extends StatelessWidget {
  const AnalyticsPieChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.chart_pie_fill,
              size: 48,
              color: CupertinoTheme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Pie Chart Area',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
