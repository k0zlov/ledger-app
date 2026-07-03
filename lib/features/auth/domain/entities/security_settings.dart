class SecuritySettings {
  const SecuritySettings({
    this.isSecurityEnabled = false,
    this.isBiometricsEnabled = false,
  });

  final bool isSecurityEnabled;
  final bool isBiometricsEnabled;

  SecuritySettings copyWith({
    bool? isSecurityEnabled,
    bool? isBiometricsEnabled,
  }) {
    return SecuritySettings(
      isSecurityEnabled: isSecurityEnabled ?? this.isSecurityEnabled,
      isBiometricsEnabled: isBiometricsEnabled ?? this.isBiometricsEnabled,
    );
  }
}
