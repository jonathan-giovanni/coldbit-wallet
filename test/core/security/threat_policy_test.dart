import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coldbit_wallet/core/security/threat_policy.dart';

void main() {
  setUp(() {
    // Inject mock values for secure storage since we are in a headless test environment
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('ThreatPolicyManager', () {
    test('getPolicy defaults to paranoid if nothing is saved', () async {
      final defaultPolicy = await ThreatPolicyManager.getPolicy();
      expect(defaultPolicy, ThreatPolicy.paranoid);
    });

    test('can save and retrieve Wipe policy', () async {
      // User detects root context and decides on "forced wipe"
      await ThreatPolicyManager.savePolicy(ThreatPolicy.wipe);
      
      final retrieved = await ThreatPolicyManager.getPolicy();
      expect(retrieved, ThreatPolicy.wipe);
    });

    test('can save and retrieve Warn policy', () async {
      // User allows the app to just warn
      await ThreatPolicyManager.savePolicy(ThreatPolicy.warn);
      
      final retrieved = await ThreatPolicyManager.getPolicy();
      expect(retrieved, ThreatPolicy.warn);
    });
  });
}
