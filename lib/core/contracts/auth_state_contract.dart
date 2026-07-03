abstract interface class AuthStatusContract {
  bool get isLocked;

  Stream<bool> get lockStateStream;
}
