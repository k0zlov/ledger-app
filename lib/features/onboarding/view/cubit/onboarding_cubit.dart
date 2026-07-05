import 'package:bloc/bloc.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:ledger_app/features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';
import 'package:ledger_app/features/onboarding/domain/use_cases/get_onboarding_progress_use_case.dart';
import 'package:ledger_app/features/onboarding/domain/use_cases/set_onboarding_progress_use_case.dart';
import 'package:meta/meta.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required this._getOnboardingProgress,
    required this._setOnboardingProgress,
    required this._completeOnboarding,
  }) : super(const OnboardingState());

  final CompleteOnboardingUseCase _completeOnboarding;
  final GetOnboardingProgressUseCase _getOnboardingProgress;
  final SetOnboardingProgressUseCase _setOnboardingProgress;

  Future<void> initialize() async {
    final result = await _getOnboardingProgress(NoParams());

    result.fold(
      (failure) {},
      (progress) => emit(state.copyWith(progress: progress)),
    );
  }

  Future<void> completeOnboarding() async {
    final result = await _completeOnboarding(NoParams());

    result.fold(
      (failure) {},
      (_) {},
    );
  }

  Future<void> updateProgress(
    OnboardingProgress newProgress,
  ) async {
    if (state.progress == newProgress) return;

    final result = await _setOnboardingProgress(newProgress);

    result.fold((failure) {}, (unit) => emit(state.copyWith(progress: newProgress)));
  }
}
