import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/widgets/amount_text.dart';

class AnimatedAmountText extends StatelessWidget {
  const AnimatedAmountText({
    required this.amount,
    this.showSign = false,
    this.style,
    this.duration = const Duration(milliseconds: 400),
    super.key,
  });

  final int amount;
  final bool showSign;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: amount.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return AmountText(
          amount: value.round(),
          showSign: showSign,
          style: style,
        );
      },
    );
  }
}
