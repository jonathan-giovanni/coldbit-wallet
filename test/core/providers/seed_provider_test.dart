import 'package:coldbit_wallet/core/crypto/mnemonic_strength.dart';
import 'package:coldbit_wallet/core/providers/seed_provider.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await MemGuard.init();
  });

  group('SeedProvider', () {
    test('generates 12-word seed material', () {
      final provider = SeedProvider();

      provider.generate(strength: MnemonicStrength.words12);

      expect(provider.words.length, 12);
    });

    test('generates 24-word seed material by default', () {
      final provider = SeedProvider();

      provider.generate();

      expect(provider.words.length, 24);
    });

    test('setSeed and wipe update sealed state access', () {
      final provider = SeedProvider();

      provider.setSeed(
        'abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about',
      );

      expect(provider.words.length, 12);

      provider.wipe();

      expect(provider.words, isEmpty);
    });
  });
}
