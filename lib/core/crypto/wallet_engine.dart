import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:coldbit_wallet/core/security/sealed_state.dart';

class WalletEngine {
  static SealedState<String> generateMnemonic() {
    final mnemonic = bip39.generateMnemonic(strength: 256);
    return SealedState<String>(mnemonic);
  }

  static bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }

  static Future<Descriptor> deriveNativeSegwit(String mnemonic, Network network) async {
    final mnemonicObj = await Mnemonic.fromString(mnemonic);
    final descriptorSecretKey = await DescriptorSecretKey.create(
      network: network,
      mnemonic: mnemonicObj,
    );
    
    return await Descriptor.newBip84(
      secretKey: descriptorSecretKey, 
      network: network, 
      keychain: KeychainKind.externalChain,
    );
  }

  static Future<PartiallySignedTransaction> parsePsbt(String psbtBase64) async {
    try {
      return await PartiallySignedTransaction.fromString(psbtBase64);
    } catch (_) {
      throw StateError('INVALID_PSBT_FORMAT');
    }
  }

  static Future<String> signPsbtOffline({
    required String psbtBase64,
    required Descriptor descriptor,
    required Network network,
  }) async {
    final psbt = await parsePsbt(psbtBase64);
    
    final wallet = await Wallet.create(
      descriptor: descriptor,
      network: network,
      databaseConfig: const DatabaseConfig.memory(),
    );

    final isSigned = await wallet.sign(
      psbt: psbt,
      signOptions: const SignOptions(
         trustWitnessUtxo: false,
         allowAllSighashes: false,
         removePartialSigs: true,
         tryFinalize: true,
         signWithTapInternalKey: false,
         allowGrinding: true,
      ),
    );
    
    if (!isSigned) {
      throw StateError('PSBT_SIGN_FAILED');
    }

    final serializedBytes = await psbt.serialize();
    return base64Encode(serializedBytes);
  }
}
