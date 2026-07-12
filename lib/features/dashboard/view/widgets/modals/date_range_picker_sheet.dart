import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/features/dashboard/view/widgets/buttons/done_button.dart';
import 'package:ledger_app/features/dashboard/view/widgets/navigation_bar/modal_navigation_bar.dart';

class DateRangePickerSheet extends StatefulWidget {
  const DateRangePickerSheet({
    required this.start,
    required this.end,
    required this.onChanged,
    super.key,
  });

  final DateTime? start;
  final DateTime? end;
  final void Function(DateTime? start, DateTime? end) onChanged;

  @override
  State<DateRangePickerSheet> createState() => _DateRangePickerSheetState();
}

class _DateRangePickerSheetState extends State<DateRangePickerSheet> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.start;
    _end = widget.end;
  }

  void _handleDateChange(DateTime? newStart, DateTime? newEnd) {
    setState(() {
      _start = newStart;
      _end = newEnd;
    });
    widget.onChanged(_start, _end);
  }

  void _handleCancel() {
    widget.onChanged(widget.start, widget.end);
    context.navigator.pop();
  }

  void _handleDone() {
    if (_start != null && _end != null && _start!.isAfter(_end!)) {
      _handleDateChange(_end, _start);
    }
    context.navigator.pop();
  }

  Future<void> _handlePickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final DateTime selected = (isStart ? _start : _end) ?? now;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 280,
        decoration: const BoxDecoration(
          color: CupertinoColors.systemGroupedBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DoneButton(onTap: () => ctx.navigator.pop()),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selected,
                  onDateTimeChanged: (date) {
                    if (isStart) {
                      _handleDateChange(date, _end);
                    } else {
                      _handleDateChange(_start, date);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return context.l10n.notSet;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$m/$d/$y';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();

    final quickOptions = [
      (
        title: l10n.today,
        start: DateTime(now.year, now.month, now.day),
        end: DateTime(now.year, now.month, now.day, 23, 59, 59),
      ),
      (
        title: l10n.thisMonth,
        start: DateTime(now.year, now.month),
        end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
      ),
      (
        title: l10n.lastMonth,
        start: DateTime(now.year, now.month - 1),
        end: DateTime(now.year, now.month, 0, 23, 59, 59),
      ),
      (
        title: l10n.thisYear,
        start: DateTime(now.year),
        end: DateTime(now.year, 12, 31, 23, 59, 59),
      ),
      (
        title: l10n.allTime,
        start: null,
        end: null,
      ),
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            ModalNavigationBar(
              title: l10n.selectDateRange,
              leftText: l10n.cancelButton,
              rightText: l10n.doneButton,
              onLeftTap: _handleCancel,
              onRightTap: _handleDone,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
                      child: Text(
                        l10n.quickOptions,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CupertinoListSection.insetGrouped(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      children: quickOptions.map((option) {
                        return _QuickOptionTile(
                          title: option.title,
                          onTap: () => _handleDateChange(option.start, option.end),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 8),
                      child: Text(
                        l10n.customRange,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CupertinoListSection.insetGrouped(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        CupertinoListTile(
                          title: Text(l10n.startDate),
                          additionalInfo: Text(
                            _formatDate(_start),
                            style: const TextStyle(color: CupertinoColors.activeBlue),
                          ),
                          onTap: () => _handlePickDate(context, true),
                        ),
                        CupertinoListTile(
                          title: Text(l10n.endDate),
                          additionalInfo: Text(
                            _formatDate(_end),
                            style: const TextStyle(color: CupertinoColors.activeBlue),
                          ),
                          onTap: () => _handlePickDate(context, false),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickOptionTile extends StatelessWidget {
  const _QuickOptionTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
