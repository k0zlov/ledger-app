import 'package:flutter/cupertino.dart';

class PinDots extends StatelessWidget {
  const PinDots({
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    super.key,
  });

  final int currentLength;
  final bool isError;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PinDot(
          isFilled: currentLength > 0,
          isError: isError,
          isSuccess: isSuccess,
        ),
        const SizedBox(width: 24),
        PinDot(
          isFilled: currentLength > 1,
          isError: isError,
          isSuccess: isSuccess,
        ),
        const SizedBox(width: 24),
        PinDot(
          isFilled: currentLength > 2,
          isError: isError,
          isSuccess: isSuccess,
        ),
        const SizedBox(width: 24),
        PinDot(
          isFilled: currentLength > 3,
          isError: isError,
          isSuccess: isSuccess,
        ),
      ],
    );
  }
}

class PinDot extends StatelessWidget {
  const PinDot({
    required this.isFilled,
    required this.isError,
    required this.isSuccess,
    super.key,
  });

  final bool isFilled;
  final bool isError;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (isError) {
      color = CupertinoColors.destructiveRed;
    } else if (isSuccess) {
      color = CupertinoColors.activeGreen;
    } else {
      color = isFilled ? CupertinoColors.activeBlue : CupertinoColors.systemGrey5;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: isFilled || isError || isSuccess ? color : CupertinoColors.activeBlue,
          width: 2,
        ),
      ),
    );
  }
}

