import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/auth/view/screens/pin_entry_screen.dart';

enum _AuthSetupStep { intro, pin, biometrics }

class AuthSetupScreen extends StatefulWidget {
  const AuthSetupScreen({
    required this.onSetupComplete,
    super.key,
  });

  final VoidCallback onSetupComplete;

  @override
  State<AuthSetupScreen> createState() => _AuthSetupScreenState();
}

class _AuthSetupScreenState extends State<AuthSetupScreen> {
  _AuthSetupStep _currentStep = _AuthSetupStep.intro;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<AuthCubit>().checkBiometricsAvailability());
  }

  Future<bool> _handlePinSubmit(String pin) async {
    final AuthCubit cubit = context.read<AuthCubit>();
    await cubit.submitPin(pin);

    final AuthState state = cubit.state;
    final bool success = state.status == AuthStatus.success;

    if (!success) return false;

    await Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return true;

      if (state.isBiometricsAvailable) {
        setState(() {
          _currentStep = _AuthSetupStep.biometrics;
        });
      } else {
        widget.onSetupComplete();
      }
    });

    return success;
  }

  Future<void> _handleBiometricsEnable() async {
    await context.read<AuthCubit>().toggleBiometrics(
      'Verify your identity to enable biometric login',
    );
    widget.onSetupComplete();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: () {
        switch (_currentStep) {
          case _AuthSetupStep.intro:
            return _IntroStep(
              key: const ValueKey('intro'),
              onSetupPin: () => setState(() => _currentStep = _AuthSetupStep.pin),
              onSkip: widget.onSetupComplete,
            );
          case _AuthSetupStep.pin:
            return PinEntryScreen(
              key: const ValueKey('pin'),
              repeatCode: true,
              onSubmit: _handlePinSubmit,
              onBack: () => setState(() => _currentStep = _AuthSetupStep.intro),
            );
          case _AuthSetupStep.biometrics:
            return _BiometricsStep(
              key: const ValueKey('biometrics'),
              onEnable: _handleBiometricsEnable,
              onSkip: widget.onSetupComplete,
            );
        }
      }(),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({
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

class _BiometricsStep extends StatelessWidget {
  const _BiometricsStep({
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
