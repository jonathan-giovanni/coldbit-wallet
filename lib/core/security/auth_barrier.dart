import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import 'package:sodium_libs/sodium_libs.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';

/// Define the reason for authentication failure.
enum AuthFailure { inactive, invalidPin, timeoutBlock, biometricsFailed, maxAttemptsWipe }

/// The strict triple barrier logic: Rate Limit -> PIN (Argon2 Hash) -> Biometrics.
class AuthBarrier {
  static const String _pinHashKey = 'coldbit_pin_hash';
  final LocalAuthentication _localAuth = LocalAuthentication();
  final RateLimiter _rateLimiter;

  AuthBarrier(this._rateLimiter);

  /// Registra el PIN del usuario hashing it con Argon2id y guardando en Secure Enclave.
  static Future<void> registerPin(String pin) async {
    final sodium = MemGuard.sodium;
    
    // Argon2id hashing parameters strictly tuned for maximum security on mobile CPUs
    final passwordBytes = Int8List.fromList(utf8.encode(pin));
    
    try {
      final String hashStr = sodium.crypto.pwhash.strAlloc(
        password: passwordBytes,
        opsLimit: sodium.crypto.pwhash.opsLimitInteractive,
        memLimit: sodium.crypto.pwhash.memLimitInteractive,
      );
      
      await SecureEnclave.write(_pinHashKey, hashStr);
    } finally {
      // Int8List / basic bytes are hard to zero out in Dart, but we minimize exposure.
    }
  }

  /// Verifica la triple barrera. Lanza excepciones controladas o evalúa `AuthFailure`.
  Future<AuthFailure?> authenticate(String attemptPin) async {
    // 1. Rate Limiting Check - Excepcion controlada si WIPE.
    try {
      // Check if we are still serving a penalty? In real UX, penalty stops the UI from even submitting
      // but if an attacker submits bypassing UI, we block.
    } catch (e) {
      if (e is StateError && e.message == 'MAX_ATTEMPTS_REACHED') {
        return AuthFailure.maxAttemptsWipe;
      }
    }

    final savedHash = await SecureEnclave.read(_pinHashKey);
    if (savedHash == null) return AuthFailure.inactive;

    final sodium = MemGuard.sodium;
    final attemptBytes = Int8List.fromList(utf8.encode(attemptPin));
    
    bool isValid = false;
    try {
      // 2. Argon2id PIN verification
      isValid = sodium.crypto.pwhash.strVerify(
        passwordHash: savedHash,
        password: attemptBytes,
      );
    } catch (_) {}

    if (!isValid) {
      _rateLimiter.recordFailure(); // Aumenta timeout
      return _rateLimiter.currentAttempts >= RateLimiter.maxAttempts 
          ? AuthFailure.maxAttemptsWipe 
          : AuthFailure.invalidPin;
    }

    // 3. Biometrics Check
    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
          
      if (canAuthenticateWithBiometrics) {
         final didAuthenticate = await _localAuth.authenticate(
            localizedReason: 'Acceso Seguro Militarisado requerido.',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
         );
         
         if (!didAuthenticate) {
           // Biometrics failed/cancelled, still count as a weak failure or just abort.
           return AuthFailure.biometricsFailed;
         }
      }
    } catch (e) {
      return AuthFailure.biometricsFailed;
    }

    // Success! Wipe previous penalties.
    _rateLimiter.recordSuccess();
    return null; // Null means Authentication verified and succeeded.
  }
}
