import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/features/settings/domain/repositories/settings_repository.dart';

class SaveAppSettingsUseCase implements UseCase<Unit, AppSettings> {
  const SaveAppSettingsUseCase({required this._repository});

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(AppSettings params) async {
    try {
      await _repository.saveAppSettings(params);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not save app settings'));
    }
  }
}
