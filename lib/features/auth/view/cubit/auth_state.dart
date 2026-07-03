part of 'auth_cubit.dart';

class AuthState {
  const AuthState({
    this.isBiometricsAvailable = false,
    this.securitySettings = const SecuritySettings(),
  });

  final bool isBiometricsAvailable;
  final SecuritySettings securitySettings;

  AuthState copyWith({
    bool? isBiometricsAvailable,
    SecuritySettings? securitySettings,
  }) {
    return AuthState(
      isBiometricsAvailable: isBiometricsAvailable ?? this.isBiometricsAvailable,
      securitySettings: securitySettings ?? this.securitySettings,
    );
  }
}
