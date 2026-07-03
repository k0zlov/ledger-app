import 'package:flutter/cupertino.dart';

class AuthSetupBiometricStep extends StatelessWidget {
  const AuthSetupBiometricStep({
    required this.onEnable,
    required this.onSkip,
    super.key,
  });

  final VoidCallback onEnable;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Biometrics'),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.person_crop_circle,
                  size: 80,
                  color: CupertinoColors.systemGrey,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Enable Biometrics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Use FaceID or TouchID to log in faster without typing your PIN.',
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
                    onPressed: onEnable,
                    child: const Text('Enable Biometrics'),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    onPressed: onSkip,
                    child: const Text('Skip for now'),
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
