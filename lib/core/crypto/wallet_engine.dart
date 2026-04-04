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
}
