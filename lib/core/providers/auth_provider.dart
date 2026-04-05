import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/providers/vault_provider.dart';
import 'package:coldbit_wallet/core/security/auth_barrier.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, loading, authenticated, error, uninitialized }

class AuthNotifier extends StateNotifier<AuthState> {

  AuthNotifier(this.ref) : super(AuthState.loading) {
    evaluateInitialState();
  }
  
  final Ref ref;

  Future<bool> unlockWithBiometrics() async {
    state = AuthState.loading;
    final barrier = AuthBarrier(RateLimiter());
    final success = await barrier.authenticateBiometricsOnly();
    if (success) {
      state = AuthState.authenticated;
      return true;
    } else {
      state = AuthState.initial;
      return false;
    }
  }

  Future<void> evaluateInitialState() async {
    state = AuthState.loading;
    final exists = await ref.read(vaultExistsProvider.future);
    if (!exists) {
      state = AuthState.uninitialized;
    } else {
      state = AuthState.initial;
    }
  }

  Future<void> setupNewVault(String pin) async {
    state = AuthState.loading;
    try {
      // 1. Generate Air-gap mnemonic
      final sealedMnem = WalletEngine.generateMnemonic();
      
      // 2. Derive to Native Segwit (Validation pass)
      final _ = await WalletEngine.deriveNativeSegwit(sealedMnem.unseal(), Network.testnet);
      
      // 3. Register PIN and seal payload
      await AuthBarrier.registerPin(pin);
      
      state = AuthState.authenticated;
    } catch (e) {
      state = AuthState.error;
    }
  }

  Future<bool> unlockVault(String pin) async {
    state = AuthState.loading;
    try {
      final rateLimiter = RateLimiter(); // standard policy
      final barrier = AuthBarrier(rateLimiter);
      final failure = await barrier.authenticate(pin);
      
      if (failure == null) {
        state = AuthState.authenticated;
        return true;
      } else {
        state = AuthState.error;
        return false;
      }
    } catch (e) {
      state = AuthState.error;
      return false;
    }
  }

  void logout() {
    state = AuthState.initial;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
