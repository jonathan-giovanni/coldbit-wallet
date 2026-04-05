import 'package:coldbit_wallet/core/security/secure_enclave.dart';

enum ThreatPolicy { wipe, paranoid, warn }

class ThreatPolicyManager {
  static const _policyKey = 'coldbit_threat_policy';

  static Future<void> savePolicy(ThreatPolicy policy) async {
    await SecureEnclave.write(_policyKey, policy.name);
  }

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
