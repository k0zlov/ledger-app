import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:ledger_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class SetOnboardingProgressUseCase implements UseCase<Unit, OnboardingProgress> {
  const SetOnboardingProgressUseCase({required this._repository});

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(OnboardingProgress params) async {
    try {
      await _repository.setOnboardingProgress(params);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not set onboarding progress'));
    }
  }
}
