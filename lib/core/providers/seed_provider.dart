import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/security/sealed_state.dart';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeedProvider extends StateNotifier<SealedState<String>?> {
  SeedProvider() : super(null);

  static const String _seedKey = 'coldbit_sealed_seed';

  void generate() {
    state?.destroy();
    state = WalletEngine.generateMnemonic();
  }

  void setSeed(String mnemonic) {
    state?.destroy();
    state = SealedState<String>(mnemonic);
  }

  List<String> get words {
    if (state == null) return [];
    return state!.unseal().split(' ');
  }

  Future<void> persist() async {
    if (state == null) return;
    await SecureEnclave.write(_seedKey, state!.unseal());
  }

  static Future<String?> loadPersistedSeed() async {
    return SecureEnclave.read(_seedKey);
  }

  void wipe() {
    state?.destroy();
    state = null;
  }
}

final seedProvider = StateNotifierProvider<SeedProvider, SealedState<String>?>(
  (ref) => SeedProvider(),
);
