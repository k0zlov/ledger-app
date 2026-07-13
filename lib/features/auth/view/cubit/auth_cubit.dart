import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';
import 'package:ledger_app/features/auth/domain/use_cases/authenticate_with_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/authenticate_with_pin_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/check_biometric_availability_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/check_pin_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/disable_pin_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/get_security_settings_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/set_pin_code_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/toggle_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/view/cubit/auth_effect.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with BlocPresentationMixin<AuthState, AuthEffect> {
  AuthCubit({
    required this._disablePinUseCase,
    required this._checkPinUseCase,
    required this._authenticateWithBiometrics,
    required this._authenticateWithPin,
    required this._setPinCode,
    required this._getSecuritySettings,
    required this._toggleBiometrics,
    required this._checkBiometricAvailability,
  }) : super(const AuthState());

  final SetPinCodeUseCase _setPinCode;
  final GetSecuritySettingsUseCase _getSecuritySettings;
  final ToggleBiometricsUseCase _toggleBiometrics;
  final CheckBiometricAvailabilityUseCase _checkBiometricAvailability;
  final AuthenticateWithBiometricsUseCase _authenticateWithBiometrics;
  final AuthenticateWithPinUseCase _authenticateWithPin;
  final CheckPinUseCase _checkPinUseCase;
  final DisablePinUseCase _disablePinUseCase;

  Future<void> initialize() async {
    final List<dynamic> results = await Future.wait([
      _getSecuritySettings(NoParams()),
      _checkBiometricAvailability(NoParams()),
    ]);

    final Either<Failure, SecuritySettings> settingsResult = results[0] as Either<Failure, SecuritySettings>;
    final Either<Failure, bool> availabilityResult = results[1] as Either<Failure, bool>;

    settingsResult.fold(
      (failure) {},
      (settings) => emit(state.copyWith(securitySettings: settings)),
    );

    availabilityResult.fold(
      (failure) {},
      (isAvailable) => emit(state.copyWith(isBiometricsAvailable: isAvailable)),
    );
  }

  Future<void> setupPin(String pin) async {
    final Either<Failure, SecuritySettings> result = await _setPinCode(
      SetPinCodeParams(
        pin: pin,
        currentSettings: state.securitySettings,
      ),
    );

    result.fold(
      (failure) {
        emitPresentation(PinFailed());
      },
      (settings) {
        emit(state.copyWith(securitySettings: settings));
        emitPresentation(PinSucceeded());
      },
    );
  }

  Future<void> toggleBiometrics(String localizedReason) async {
    final Either<Failure, SecuritySettings> result = await _toggleBiometrics(
      ToggleBiometricsParams(
        reason: localizedReason,
        currentSettings: state.securitySettings,
      ),
    );

    result.fold(
      (failure) {
        emitPresentation(BiometricFailed());
      },
      (settings) {
        emit(state.copyWith(securitySettings: settings));
        emitPresentation(BiometricSucceeded());
      },
    );
  }

  Future<void> authenticateWithPin(String pin) async {
    final result = await _authenticateWithPin(pin);

    result.fold(
      (failure) {
        emitPresentation(PinFailed());
      },
      (success) {
        emitPresentation(success ? PinSucceeded() : PinFailed());
      },
    );
  }

  Future<void> authenticateWithBiometrics(String reason) async {
    final result = await _authenticateWithBiometrics(reason);

    result.fold(
      (failure) {
        emitPresentation(BiometricFailed());
      },
      (success) {
        emitPresentation(success ? BiometricSucceeded() : BiometricFailed());
      },
    );
  }

  Future<void> checkPin(String pin) async {
    final result = await _checkPinUseCase(pin);

    result.fold(
      (failure) {
        emitPresentation(PinFailed());
      },
      (success) {
        emitPresentation(success ? PinSucceeded() : PinFailed());
      },
    );
  }

  Future<void> disablePin(String pin) async {
    final result = await _disablePinUseCase(
      DisablePinParams(
        pin: pin,
        currentSettings: state.securitySettings,
      ),
    );

    result.fold(
      (failure) {
        emitPresentation(PinFailed());
      },
      (settings) {
        if (settings != null) {
          emit(state.copyWith(securitySettings: settings));
          emitPresentation(PinSucceeded());
        } else {
          emitPresentation(PinFailed());
        }
      },
    );
  }
}
