import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/navigation/navigation_service.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_cubit.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_effect.dart';
import 'package:ledger_app/features/auth/view/screens/pin_entry_screen.dart';

class AuthSettingsScreen extends StatefulWidget {
  const AuthSettingsScreen({super.key});

  @override
  State<AuthSettingsScreen> createState() => _AuthSettingsScreenState();
}

class _AuthSettingsScreenState extends State<AuthSettingsScreen> {
  Completer<bool>? _pinCompleter;

  Future<void> _setupPin() async {
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (screenContext) => PinEntryScreen(
          repeatCode: true,
          onBack: () => screenContext.navigator.pop(),
          onSubmit: (pin) async {
            _pinCompleter = Completer<bool>();
            unawaited(context.read<AuthCubit>().setupPin(pin));
            final result = await _pinCompleter!.future;
            if (result && screenContext.mounted) {
              screenContext.navigator.pop();
            }
            return result;
          },
        ),
      ),
    );
  }

  Future<void> _disablePin() async {
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (screenContext) => PinEntryScreen(
          repeatCode: false,
          onBack: () => screenContext.navigator.pop(),
          onSubmit: (pin) async {
            _pinCompleter = Completer<bool>();
            unawaited(context.read<AuthCubit>().disablePin(pin));
            final result = await _pinCompleter!.future;
            if (result && screenContext.mounted) {
              screenContext.navigator.pop();
            }
            return result;
          },
        ),
      ),
    );
  }

  Future<void> _changePin() async {
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (screenContext) => PinEntryScreen(
          repeatCode: false,
          onBack: () => screenContext.navigator.pop(),
          onSubmit: (currentPin) async {
            _pinCompleter = Completer<bool>();
            unawaited(context.read<AuthCubit>().checkPin(currentPin));
            final isCorrect = await _pinCompleter!.future;

            if (isCorrect) {
              if (screenContext.mounted) screenContext.navigator.pop();

              if (!mounted) return true;

              await Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (newPinContext) => PinEntryScreen(
                    repeatCode: true,
                    onBack: () => newPinContext.navigator.pop(),
                    onSubmit: (newPin) async {
                      _pinCompleter = Completer<bool>();
                      unawaited(context.read<AuthCubit>().setupPin(newPin));
                      final isSaved = await _pinCompleter!.future;
                      if (newPinContext.mounted) newPinContext.navigator.pop();
                      return isSaved;
                    },
                  ),
                ),
              );
            }
            return isCorrect;
          },
        ),
      ),
    );
  }

  Future<void> _toggleBiometrics() async {
    final cubit = context.read<AuthCubit>();
    final state = cubit.state;

    if (!state.securitySettings.isSecurityEnabled) {
      unawaited(
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(context.l10n.pinRequired),
            content: Text(context.l10n.pinRequiredForBiometrics),
            actions: [
              CupertinoDialogAction(
                child: Text(context.l10n.ok),
                onPressed: () => context.navigator.pop(),
              ),
            ],
          ),
        ),
      );
      return;
    }

    if (state.isBiometricsAvailable) {
      await cubit.toggleBiometrics(
        context.l10n.verifyIdentityToEnableBiometrics,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.select<AuthCubit, AuthState>((c) => c.state);

    final isPinSet = state.securitySettings.isSecurityEnabled;
    final isBiometricsEnabled = state.securitySettings.isBiometricsEnabled;

    return BlocPresentationListener<AuthCubit, AuthEffect>(
      listener: (context, effect) {
        switch (effect) {
          case PinFailed():
          case BiometricFailed():
            if (_pinCompleter?.isCompleted == false) {
              _pinCompleter?.complete(false);
            }
          case PinSucceeded():
          case BiometricSucceeded():
            if (_pinCompleter?.isCompleted == false) {
              _pinCompleter?.complete(true);
            }
        }
      },
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
          middle: Text(l10n.authSecurity),
          previousPageTitle: l10n.backButton,
        ),
        child: SafeArea(
          child: ListSection(
            children: [
              if (!isPinSet)
                CupertinoListTile(
                  title: Text(l10n.setPin),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _setupPin,
                ),
              if (isPinSet) ...[
                CupertinoListTile(
                  title: Text(l10n.changePin),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _changePin,
                ),
                CupertinoListTile(
                  title: Text(l10n.disablePin),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _disablePin,
                ),
              ],
              if (state.isBiometricsAvailable)
                CupertinoListTile(
                  title: Text(l10n.biometrics),
                  additionalInfo: Text(
                    isBiometricsEnabled ? l10n.enabled : l10n.disabled,
                    style: TextStyle(
                      color: isBiometricsEnabled ? CupertinoColors.systemGreen : CupertinoColors.systemGrey,
                    ),
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _toggleBiometrics,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
