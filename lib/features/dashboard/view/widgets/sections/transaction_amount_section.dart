import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/currencies/currencies.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';
import 'package:ledger_app/core/view/widgets/amount_text.dart';

class TransactionAmountSection extends StatefulWidget {
  const TransactionAmountSection({
    required this.isEditing,
    required this.categoryType,
    required this.amount,
    required this.controller,
    this.allowSignToggle = true,
    super.key,
  });

  final bool isEditing;
  final CategoryType categoryType;
  final int amount;
  final TextEditingController controller;
  final bool allowSignToggle;

  @override
  State<TransactionAmountSection> createState() => _TransactionAmountSectionState();
}

class _TransactionAmountSectionState extends State<TransactionAmountSection> {
  String _currencySymbol = '';
  bool _symbolOnLeft = true;
  bool _spaceBetween = false;
  bool _isNegative = false;

  @override
  void initState() {
    super.initState();
    _loadCurrencyInfo();
    _syncSignFromController();
  }

  @override
  void didUpdateWidget(TransactionAmountSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryType != widget.categoryType) {
      _enforceCategoryRules();
    }
    if (oldWidget.amount != widget.amount) {
      _syncSignFromController();
    }
  }

  void _loadCurrencyInfo() {
    final currencyCode = context.read<SettingsCubit>().state.appSettings.currency;
    final currencyInfo = currencies[currencyCode] ?? currencies['USD']!;

    _currencySymbol = currencyInfo.symbol;
    _symbolOnLeft = currencyInfo.symbolOnLeft;
    _spaceBetween = currencyInfo.spaceBetweenAmountAndSymbol;
  }

  void _syncSignFromController() {
    final text = widget.controller.text;
    setState(() {
      _isNegative = text.startsWith('-') || widget.amount < 0 || widget.categoryType == .expense;
    });
  }

  void _enforceCategoryRules() {
    final cleanText = widget.controller.text.replaceAll(RegExp('[-+]'), '');
    final String newText = cleanText;

    if (widget.categoryType == CategoryType.expense) {
      _isNegative = true;
    } else if (widget.categoryType == CategoryType.income) {
      _isNegative = false;
    }

    if (widget.controller.text != newText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      });
    }
  }

  void _toggleSign() {
    if (!widget.allowSignToggle) return;
    if (widget.categoryType != CategoryType.any) return;

    setState(() {
      _isNegative = !_isNegative;
    });

    final clean = widget.controller.text.replaceAll(RegExp('[-+]'), '');
    widget.controller.value = TextEditingValue(
      text: clean,
      selection: TextSelection.collapsed(offset: clean.length),
    );
  }

  String _buildPrefix() {
    String prefix = _isNegative ? '- ' : '+ ';

    if (_symbolOnLeft) {
      prefix += _spaceBetween ? '$_currencySymbol ' : _currencySymbol;
    }

    return prefix;
  }

  String _buildSuffix() {
    if (!_symbolOnLeft) {
      return _spaceBetween ? ' $_currencySymbol' : _currencySymbol;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing) {
      return _EditableAmountField(
        controller: widget.controller,
        prefix: _buildPrefix(),
        suffix: _buildSuffix(),
        onSignTap: _toggleSign,
      );
    }

    int displayAmount = widget.amount;
    if (widget.categoryType == CategoryType.expense) {
      displayAmount = -widget.amount.abs();
    } else if (widget.categoryType == CategoryType.income) {
      displayAmount = widget.amount.abs();
    }

    return AmountText(
      amount: displayAmount,
      showSign: true,
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        letterSpacing: -1,
      ),
    );
  }
}

class _EditableAmountField extends StatelessWidget {
  const _EditableAmountField({
    required this.controller,
    required this.prefix,
    required this.suffix,
    required this.onSignTap,
  });

  final TextEditingController controller;
  final String prefix;
  final String suffix;
  final VoidCallback onSignTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onSignTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefix.isNotEmpty)
              Text(
                prefix,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
            IntrinsicWidth(
              child: CupertinoTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                padding: EdgeInsetsGeometry.zero,
                clearButtonMode: OverlayVisibilityMode.editing,
                placeholder: '0',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
                decoration: const BoxDecoration(),
              ),
            ),
            if (suffix.isNotEmpty)
              Text(
                suffix,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
