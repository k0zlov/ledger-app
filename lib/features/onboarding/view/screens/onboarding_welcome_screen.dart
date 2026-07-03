import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/localization/localization_build_context_x.dart';

class OnboardingWelcomingScreen extends StatelessWidget {
  const OnboardingWelcomingScreen({
    required this.onGetStarted,
    super.key,
  });

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.welcomeTitle),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.graph_square,
                  size: 80,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.welcomeHeading,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.welcomeDescription,
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
                    onPressed: onGetStarted,
                    child: Text(l10n.getStartedButton),
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