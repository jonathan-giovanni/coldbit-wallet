import 'package:coldbit_wallet/core/security/secure_enclave.dart';

/// Niveles de Política dictaminados por el usuario
/// en caso de que su dispositivo sea hostil (Root/Jailbreak).
enum ThreatPolicy {
  wipe,       // Borrado Silencioso Permanente (Forced Wipe)
  paranoid,   // Multi-Factor Agresivo Severo
  warn,       // Advertencia Sutil o Tolerada
}

class ThreatPolicyManager {
  static const _policyKey = 'coldbit_threat_policy';

  /// Guarda la política elegida directamente en el Secure Enclave.
  static Future<void> savePolicy(ThreatPolicy policy) async {
    await SecureEnclave.write(_policyKey, policy.name);
  }

  /// Dictamina cuál es la política. Por defecto (fail-close), asume Paranoid
  /// si no hay política establecida por el usuario y hay riesgo alto.
  static Future<ThreatPolicy> getPolicy() async {
    final policyName = await SecureEnclave.read(_policyKey);
    if (policyName == null) {
      return ThreatPolicy.paranoid; 
    }
    return ThreatPolicy.values.firstWhere(
      (e) => e.name == policyName,
      orElse: () => ThreatPolicy.paranoid,
    );
  }
}
