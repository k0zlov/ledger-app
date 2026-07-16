import 'package:flutter/cupertino.dart';

class PinPadButton extends StatelessWidget {
  const PinPadButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(36),
        color: CupertinoColors.systemGrey5.resolveFrom(context),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label.resolveFrom(context),
          ),
        ),
      ),
    );
  }
}
