import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/currencies/currencies.dart';
import 'package:ledger_app/core/view/cubits/settings_cubit.dart';

class AmountText extends StatelessWidget {
  const AmountText({
    required this.amount,
    this.showSign = false,
    this.style,
    super.key,
  });

  final int amount;
  final bool showSign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final currencyCode = context.select<SettingsCubit, String>((c) => c.state.appSettings.currency);
    final currencyInfo = currencies[currencyCode] ?? currencies['USD']!;

    final symbol = currencyInfo.symbol;
    final value = amount.abs().toString();
    final spacing = currencyInfo.spaceBetweenAmountAndSymbol ? ' ' : '';

    final formattedValue = currencyInfo.symbolOnLeft ? '$symbol$spacing$value' : '$value$spacing$symbol';

    String finalText = formattedValue;

    if (amount < 0) {
      finalText = '-$formattedValue';
    } else if (showSign && amount > 0) {
      finalText = '+$formattedValue';
    }

    Color? getTextColor() {
      if (amount < 0) return CupertinoColors.systemRed;
      if (amount > 0 && showSign) return CupertinoColors.systemGreen;
      return style?.color;
    }

    return Text(
      finalText,
      style: (style ?? const TextStyle()).copyWith(color: getTextColor()),
    );
  }
}
