import 'package:flutter/cupertino.dart';

class ModalNavigationBar extends StatelessWidget {
  const ModalNavigationBar({
    required this.title,
    required this.leftText,
    required this.rightText,
    this.onLeftTap,
    this.onRightTap,
    super.key,
  });

  final String title;
  final String leftText;
  final String rightText;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          Positioned(
            left: 0,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: onLeftTap,
              child: Text(leftText),
            ),
          ),
          Positioned(
            right: 0,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              onPressed: onRightTap,
              child: Text(
                rightText,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
