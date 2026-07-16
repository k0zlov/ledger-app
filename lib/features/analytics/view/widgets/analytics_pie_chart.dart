import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/localization/generated/app_localizations.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/analytics/view/widgets/category_list.dart';

class AnalyticsPieChart extends StatefulWidget {
  const AnalyticsPieChart({
    required this.data,
    super.key,
  });

  final List<CategoryRowData> data;

  @override
  State<AnalyticsPieChart> createState() => _AnalyticsPieChartState();
}

class _AnalyticsPieChartState extends State<AnalyticsPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEmpty = widget.data.where((d) => d.currentSpent > 0).isEmpty;

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: isEmpty
                ? null
                : (event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: isEmpty ? 0 : 2,
          centerSpaceRadius: isEmpty ? 50 : 40,
          centerSpaceColor: isEmpty ? null : CupertinoColors.systemBackground.resolveFrom(context),
          sections: isEmpty ? _emptySection(l10n) : _showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _emptySection(AppLocalizations l10n) {
    return [
      PieChartSectionData(
        color: CupertinoColors.systemGrey4.resolveFrom(context),
        value: 100,
        title: l10n.noDataAvailable,
        titlePositionPercentageOffset: -.8,
        showTitle: true,
        radius: 65,
        titleStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
          height: 1.3,
        ),
      ),
    ];
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 65.0 : 50.0;
      final item = widget.data[i];
      final color = Color(item.category.color);

      return PieChartSectionData(
        color: color,
        value: item.currentSpent,
        title: isTouched ? '${item.category.name}\n\$${item.currentSpent.toInt()}' : '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: CupertinoColors.white,
          height: 1.2,
          shadows: [
            Shadow(
              color: Color(0x80000000),
              blurRadius: 4,
            ),
          ],
        ),
      );
    });
  }
}
