import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_effect.dart';
import 'package:ledger_app/features/auth/view/screens/pin_entry_screen.dart';
import 'package:ledger_app/features/auth/view/widgets/auth_setup/auth_setup_biometric_step.dart';
import 'package:ledger_app/features/auth/view/widgets/auth_setup/auth_setup_intro_step.dart';

enum _AuthSetupStep { intro, pin, biometrics }

class AuthSetupScreen extends StatefulWidget {
  const AuthSetupScreen({required this.onSetupComplete, super.key});

  final VoidCallback onSetupComplete;

  @override
  State<AuthSetupScreen> createState() => _AuthSetupScreenState();
}

class _AuthSetupScreenState extends State<AuthSetupScreen> {
  AuthCubit get _cubit => context.read<AuthCubit>();
  _AuthSetupStep _currentStep = .intro;

  Completer<bool>? _pinCompleter;

  Future<bool> _handlePinSubmit(String pin) {
    _pinCompleter = Completer();

    unawaited(_cubit.setupPin(pin));

    return _pinCompleter!.future;
  }

  void _handleBiometricEnable() {
    unawaited(_cubit.toggleBiometrics('Verify your identity to enable biometric login'));
  }

  void _pushStep(_AuthSetupStep step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthState state = context.select<AuthCubit, AuthState>((c) => c.state);

    return BlocPresentationListener<AuthCubit, AuthEffect>(
      listener: (context, effect) {
        switch (effect) {
          case PinSetupFailed():
            if (_pinCompleter?.isCompleted == false) {
              _pinCompleter?.complete(false);
            }
          case PinSetupSucceeded():
            if (_pinCompleter?.isCompleted == false) {
              _pinCompleter?.complete(true);
            }

            Future.delayed(const Duration(milliseconds: 350), () {
              if (!mounted) return;
              if (state.isBiometricsAvailable) {
                _pushStep(.biometrics);
              } else {
                widget.onSetupComplete();
              }
            });
          case BiometricSucceeded():
            widget.onSetupComplete();
          case BiometricFailed():
        }
      },
      child: AnimatedSwitcher(
        switchInCurve: Curves.fastEaseInToSlowEaseOut,
        switchOutCurve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 300),
        child: () {
          switch (_currentStep) {
            case _AuthSetupStep.intro:
              return AuthSetupIntroStep(
                key: const ValueKey('intro'),
                onSetupPin: () => _pushStep(.pin),
                onSkip: widget.onSetupComplete,
              );
            case _AuthSetupStep.pin:
              return PinEntryScreen(
                key: const ValueKey('pin'),
                repeatCode: true,
                onSubmit: _handlePinSubmit,
                onBack: () => _pushStep(.intro),
              );
            case _AuthSetupStep.biometrics:
              return AuthSetupBiometricStep(
                key: const ValueKey('biometrics'),
                onEnable: _handleBiometricEnable,
                onSkip: widget.onSetupComplete,
              );
          }
        }(),
      ),
    );
  }
}
