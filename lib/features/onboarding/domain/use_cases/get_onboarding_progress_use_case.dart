import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:ledger_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingProgressUseCase implements UseCase<OnboardingProgress, NoParams> {
  const GetOnboardingProgressUseCase({required this._repository});

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, OnboardingProgress>> call(NoParams params) async {
    try {
      final OnboardingProgress entity = await _repository.getOnboardingProgress();
      return Right(entity);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not get onboarding progress'));
    }
  }
}
