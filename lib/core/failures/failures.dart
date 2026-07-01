sealed class Failure {
  const Failure({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  String toString() {
    return 'Failure{errorMessage: $errorMessage}';
  }
}

final class CacheFailure extends Failure {
  const CacheFailure({required super.errorMessage});

  @override
  String toString() {
    return 'CacheFailure{errorMessage: ${super.errorMessage}';
  }
}
