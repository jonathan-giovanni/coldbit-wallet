import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await MemGuard.init();
  });

  group('WalletEngine', () {
    test('generateMnemonic generates valid 256-bit mnemonic', () {
      final mnemonicState = WalletEngine.generateMnemonic();
      final phrase = mnemonicState.unseal();
      
      // 256 bits of entropy generates exactly 24 words
      expect(phrase.split(' ').length, 24);
      expect(WalletEngine.validateMnemonic(phrase), true);
    });

    test('deriveNativeSegwit returns Descriptor for BIP84', () async {
      final mnemonicState = WalletEngine.generateMnemonic();
      final phrase = mnemonicState.unseal();
      
      final descriptor = await WalletEngine.deriveNativeSegwit(phrase, Network.testnet);
      final descriptorString = descriptor.asString();
      
      // Mnemonic derivation starts with wpkh (Witness Public Key Hash - BIP84 SegWit)
      expect(descriptorString.startsWith('wpkh'), true);
    }, skip: 'Requires BDK native FFI library built via Xcode or device');

    test('parsePsbt throws StateError on invalid base64', () async {
      expect(
        () async => await WalletEngine.parsePsbt('invalid_structure_for_psbt'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
