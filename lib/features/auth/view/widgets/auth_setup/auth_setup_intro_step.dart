import 'package:flutter/cupertino.dart';

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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Security Setup'),
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
                const Text(
                  'Secure your Ledger',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Would you like to set up a PIN code to protect your financial data?',
                  style: TextStyle(
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
                    child: const Text('Set Up PIN Code'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: onSkip,
                    child: const Text('Skip'),
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
