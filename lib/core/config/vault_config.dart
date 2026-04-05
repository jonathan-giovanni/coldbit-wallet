class VaultConfig {
  VaultConfig._();

  static const int pinLength = 8;
  static const int maxAuthAttempts = 20;
  static const Duration inactivityTimeout = Duration(minutes: 2);
}
