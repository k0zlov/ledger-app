import 'package:fpdart/fpdart.dart';
import 'package:ledger_app/core/domain/entities/app_settings.dart';
import 'package:ledger_app/core/failures/failures.dart';
import 'package:ledger_app/core/use_case/use_case.dart';
import 'package:ledger_app/features/settings/domain/repositories/settings_repository.dart';

class GetAppSettingsUseCase implements UseCase<AppSettings, NoParams> {
  const GetAppSettingsUseCase({required this._repository});

  final SettingsRepository _repository;

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) async {
    try {
      final AppSettings entity = await _repository.getAppSettings();
      return Right(entity);
    } catch (e) {
      return const Left(CacheFailure(errorMessage: 'Could not get app settings'));
    }
  }
}
