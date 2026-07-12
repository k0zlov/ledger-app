import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class AuthSetupIntroStep extends StatelessWidget {
  const AuthSetupIntroStep({
    required this.onSetupPin,
    required this.onSkip,
    super.key,
  });

  final VoidCallback onSetupPin;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.securitySetupTitle),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.lock_shield,
                  size: 80,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.secureYourLedgerHeading,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.setupPinDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: onSetupPin,
                    child: Text(l10n.setupPinButton),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: onSkip,
                    child: Text(l10n.skipButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
