import 'package:flutter/cupertino.dart';

class OnboardingWelcomingScreen extends StatelessWidget {
  const OnboardingWelcomingScreen({
    required this.onGetStarted,
    super.key,
  });

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Welcome'),
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
                const Text(
                  'Welcome to Ledger',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'The simplest way to track your expenses, manage your accounts, and secure your financial data.',
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
                    onPressed: onGetStarted,
                    child: const Text('Get Started'),
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
