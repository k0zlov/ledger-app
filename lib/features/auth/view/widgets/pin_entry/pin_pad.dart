import 'package:flutter/cupertino.dart';
import 'package:ledger_app/features/auth/view/widgets/pin_entry/pid_pad_button.dart';
import 'package:ledger_app/features/auth/view/widgets/pin_entry/pin_pad_action_button.dart';

class PinPad extends StatelessWidget {
  const PinPad({
    required this.onKeyPressed,
    required this.onBackspace,
    this.onBiometricsButton,
    super.key,
  });

  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback? onBiometricsButton;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PinPadButton(text: '1', onPressed: () => onKeyPressed('1')),
              PinPadButton(text: '2', onPressed: () => onKeyPressed('2')),
              PinPadButton(text: '3', onPressed: () => onKeyPressed('3')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PinPadButton(text: '4', onPressed: () => onKeyPressed('4')),
              PinPadButton(text: '5', onPressed: () => onKeyPressed('5')),
              PinPadButton(text: '6', onPressed: () => onKeyPressed('6')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PinPadButton(text: '7', onPressed: () => onKeyPressed('7')),
              PinPadButton(text: '8', onPressed: () => onKeyPressed('8')),
              PinPadButton(text: '9', onPressed: () => onKeyPressed('9')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PinPadActionButton(
                icon: CupertinoIcons.person,
                onPressed: onBiometricsButton,
              ),
              PinPadButton(text: '0', onPressed: () => onKeyPressed('0')),
              PinPadActionButton(
                icon: CupertinoIcons.delete_left,
                onPressed: onBackspace,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
