class VaultConfig {
  VaultConfig._();

  static const int pinLength = 6;
  static const int maxAuthAttempts = 20;
  static const Duration inactivityTimeout = Duration(minutes: 2);
}
