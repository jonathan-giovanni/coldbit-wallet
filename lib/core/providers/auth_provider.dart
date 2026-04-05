import 'package:coldbit_wallet/core/providers/vault_provider.dart';
import 'package:coldbit_wallet/core/security/auth_barrier.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  error,
  uninitialized,
  seedPending,
}

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
      await AuthBarrier.registerPin(pin);
      state = AuthState.seedPending;
    } catch (e) {
      state = AuthState.error;
    }
  }

  void completeSeedBackup() {
    state = AuthState.authenticated;
  }

  Future<AuthResult> unlockVault(String pin) async {
    state = AuthState.loading;
    try {
      final rateLimiter = RateLimiter(); // standard policy
      final barrier = AuthBarrier(rateLimiter);
      final result = await barrier.authenticate(pin);

      if (result is AuthSuccess) {
        state = AuthState.authenticated;
      } else if (result is AuthMaxAttemptsWiped) {
        state = AuthState.uninitialized; // Furia de Dios (Wiped)
      } else {
        state = AuthState.initial;
      }
      return result;
    } catch (e) {
      state = AuthState.error;
      return AuthInvalidPin();
    }
  }

  void logout() {
    state = AuthState.initial;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
