import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton.filled(
          onPressed: onPressed,
          child: Text(context.l10n.continueButton),
        ),
      ),
    );
  }
}
