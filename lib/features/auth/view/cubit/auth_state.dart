part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.isBiometricsAvailable = false,
    this.isBiometricsEnabled = false,
  });

  final AuthStatus status;
  final bool isBiometricsAvailable;
  final bool isBiometricsEnabled;

  AuthState copyWith({
    AuthStatus? status,
    bool? isBiometricsAvailable,
    bool? isBiometricsEnabled,
  }) {
    return AuthState(
      status: status ?? this.status,
      isBiometricsAvailable: isBiometricsAvailable ?? this.isBiometricsAvailable,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
    );
  }
}
