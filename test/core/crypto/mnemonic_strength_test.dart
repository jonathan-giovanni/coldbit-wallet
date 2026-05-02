import 'package:coldbit_wallet/core/crypto/mnemonic_strength.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MnemonicStrength', () {
    test('maps supported word counts to entropy', () {
      expect(MnemonicStrength.words12.wordCount, 12);
      expect(MnemonicStrength.words12.entropyBits, 128);
      expect(MnemonicStrength.words24.wordCount, 24);
      expect(MnemonicStrength.words24.entropyBits, 256);
    });

    test('rejects unsupported word counts', () {
      expect(
        () => MnemonicStrength.fromWordCount(18),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
