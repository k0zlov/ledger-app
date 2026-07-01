import 'package:flutter/cupertino.dart';

class PinPadActionButton extends StatelessWidget {
  const PinPadActionButton({
    this.icon,
    this.onPressed,
    super.key,
  });

  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (icon == null || onPressed == null) {
      return const SizedBox(width: 72, height: 72);
    }

    return SizedBox(
      width: 72,
      height: 72,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Icon(
          icon,
          size: 32,
          color: CupertinoColors.label,
        ),
      ),
    );
  }
}
