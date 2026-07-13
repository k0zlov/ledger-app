import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_effect.dart';
import 'package:ledger_app/features/auth/view/screens/pin_entry_screen.dart';

class AuthLockScreen extends StatefulWidget {
  const AuthLockScreen({super.key});

  @override
  State<AuthLockScreen> createState() => _AuthLockScreenState();
}

class _AuthLockScreenState extends State<AuthLockScreen> {
  AuthCubit get _cubit => context.read<AuthCubit>();
  Completer<bool>? _completer;

  Future<bool> _handlePinSubmit(String pin) {
    _completer = Completer();

    unawaited(_cubit.authenticateWithPin(pin));
    return _completer!.future;
  }

  Future<bool> _handleBiometrics() {
    _completer = Completer();

    unawaited(
      _cubit.authenticateWithBiometrics('Verify your identity to login'),
    );
    return _completer!.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<AuthCubit, AuthEffect>(
      listener: (context, effect) {
        switch (effect) {
          case PinFailed():
          case BiometricFailed():
            if (_completer?.isCompleted == false) {
              _completer?.complete(false);
            }

          case PinSucceeded():
          case BiometricSucceeded():
            if (_completer?.isCompleted == false) {
              _completer?.complete(true);
            }
        }
      },
      child: BlocSelector<AuthCubit, AuthState, SecuritySettings>(
        selector: (state) => state.securitySettings,
        builder: (context, state) {
          return PinEntryScreen(
            repeatCode: false,
            autoTriggerBiometrics: true,
            onBiometrics: state.isBiometricsEnabled ? _handleBiometrics : null,
            onSubmit: _handlePinSubmit,
          );
        },
      ),
    );
  }
}
