import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class DoneButton extends StatelessWidget {
  const DoneButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoButton(
      onPressed: onTap,
      child: Text(l10n.doneButton, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
