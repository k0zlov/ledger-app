import 'package:ledger_app/features/auth/domain/entities/security_settings.dart';

class SecuritySettingsModel {
  const SecuritySettingsModel({
    this.isSecurityEnabled,
    this.isBiometricsEnabled,
  });

  factory SecuritySettingsModel.fromEntity(SecuritySettings entity) {
    return SecuritySettingsModel(
      isSecurityEnabled: entity.isBiometricsEnabled.toString(),
      isBiometricsEnabled: entity.isBiometricsEnabled.toString(),
    );
  }

  factory SecuritySettingsModel.fromJson(Map<String, dynamic> json) {
    return SecuritySettingsModel(
      isSecurityEnabled: json['isSecurityEnabled'] as String?,
      isBiometricsEnabled: json['isBiometricsEnabled'] as String?,
    );
  }

  final String? isSecurityEnabled;
  final String? isBiometricsEnabled;

  Map<String, dynamic> toJson() {
    return {
      'isSecurityEnabled': isSecurityEnabled,
      'isBiometricsEnabled': isBiometricsEnabled,
    };
  }

  SecuritySettings toEntity() {
    return SecuritySettings(
      isSecurityEnabled: isSecurityEnabled?.toLowerCase() == 'true',
      isBiometricsEnabled: isBiometricsEnabled?.toLowerCase() == 'true',
    );
  }
}
