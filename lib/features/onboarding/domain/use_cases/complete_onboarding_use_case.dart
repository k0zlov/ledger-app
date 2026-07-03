import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase implements UseCase<Unit, NoParams> {
  const CompleteOnboardingUseCase({required this._repository});

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      await _repository.completeOnboarding();

      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not complete onboarding'));
    }
  }
}
