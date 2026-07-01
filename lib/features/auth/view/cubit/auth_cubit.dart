import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/check_biometrics_availability_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/enable_biometrics_use_case.dart';
import 'package:ledger_app/features/auth/domain/use_cases/setup_pin_code_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this._setupPinCode,
    required this._checkBiometricsAvailability,
    required this._enableBiometrics,
  }) : super(const AuthState());

  final SetupPinCodeUseCase _setupPinCode;
  final CheckBiometricsAvailabilityUseCase _checkBiometricsAvailability;
  final EnableBiometricsUseCase _enableBiometrics;

  Future<void> checkBiometricsAvailability() async {
    final result = await _checkBiometricsAvailability(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
        ),
      ),
      (isAvailable) => emit(
        state.copyWith(
          isBiometricsAvailable: isAvailable,
        ),
      ),
    );
  }

  Future<void> toggleBiometrics(String localizedReason) async {
    final result = await _enableBiometrics(localizedReason);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          isBiometricsEnabled: false,
        ),
      ),
      (isAuthenticated) => emit(
        state.copyWith(
          isBiometricsEnabled: isAuthenticated,
        ),
      ),
    );
  }

  Future<void> submitPin(String pin) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _setupPinCode(pin);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.success,
        ),
      ),
    );
  }
}
