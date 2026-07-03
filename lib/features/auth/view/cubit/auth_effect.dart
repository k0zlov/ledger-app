sealed class AuthEffect {
  const AuthEffect();
}

class PinSetupFailed extends AuthEffect {}

class PinSetupSucceeded extends AuthEffect {}

class BiometricFailed extends AuthEffect {}

class BiometricSucceeded extends AuthEffect {}
