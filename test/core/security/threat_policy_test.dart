import 'package:coldbit_wallet/core/security/threat_policy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('ThreatPolicyManager', () {
    test('getPolicy defaults to paranoid', () async {
      final defaultPolicy = await ThreatPolicyManager.getPolicy();
      expect(defaultPolicy, ThreatPolicy.paranoid);
    });

    test('saves and retrieves Wipe', () async {
      await ThreatPolicyManager.savePolicy(ThreatPolicy.wipe);
      final retrieved = await ThreatPolicyManager.getPolicy();
      expect(retrieved, ThreatPolicy.wipe);
    });

    test('saves and retrieves Warn', () async {
      await ThreatPolicyManager.savePolicy(ThreatPolicy.warn);
      final retrieved = await ThreatPolicyManager.getPolicy();
      expect(retrieved, ThreatPolicy.warn);
    });
  });
}
