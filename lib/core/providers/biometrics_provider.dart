import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricSetupCompletedProvider = FutureProvider<bool>((ref) async {
  final val = await SecureEnclave.read('biometrics_setup_completed');
  return val == 'true';
});

final biometricsEnabledProvider = FutureProvider<bool>((ref) async {
  final val = await SecureEnclave.read('biometrics_enabled');
  return val == 'true';
});

class ColdBitSettings {
  static Future<void> completeBiometricSetup(bool enabled) async {
    await SecureEnclave.write('biometrics_setup_completed', 'true');
    await SecureEnclave.write('biometrics_enabled', enabled ? 'true' : 'false');
  }

  static Future<void> updateBiometricsStatus(bool enabled) async {
    await SecureEnclave.write('biometrics_enabled', enabled ? 'true' : 'false');
  }
}
