sealed class AuthEffect {
  const AuthEffect();
}

class PinFailed extends AuthEffect {}

class PinSucceeded extends AuthEffect {}

class BiometricFailed extends AuthEffect {}

class BiometricSucceeded extends AuthEffect {}

