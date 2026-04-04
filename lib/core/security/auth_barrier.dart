import 'dart:convert';
import 'dart:typed_data';
import 'package:local_auth/local_auth.dart';
import 'package:sodium_libs/sodium_libs.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';

enum AuthFailure { inactive, invalidPin, timeoutBlock, biometricsFailed, maxAttemptsWipe }

class AuthBarrier {
  static const String _pinHashKey = 'coldbit_pin_hash';
  final LocalAuthentication _localAuth = LocalAuthentication();
  final RateLimiter _rateLimiter;

  AuthBarrier(this._rateLimiter);

  static Future<void> registerPin(String pin) async {
    final sodium = MemGuard.sodium;
    
    final passwordBytes = Int8List.fromList(utf8.encode(pin));
    
    try {
      final String hashStr = sodium.crypto.pwhash.strAlloc(
        password: passwordBytes,
        opsLimit: sodium.crypto.pwhash.opsLimitInteractive,
        memLimit: sodium.crypto.pwhash.memLimitInteractive,
      );
      
      await SecureEnclave.write(_pinHashKey, hashStr);
    } finally {
    }
  }

  Future<AuthFailure?> authenticate(String attemptPin) async {
    final savedHash = await SecureEnclave.read(_pinHashKey);
    if (savedHash == null) return AuthFailure.inactive;

    final sodium = MemGuard.sodium;
    final attemptBytes = Int8List.fromList(utf8.encode(attemptPin));
    
    bool isValid = false;
    try {
      isValid = sodium.crypto.pwhash.strVerify(
        passwordHash: savedHash,
        password: attemptBytes,
      );
    } catch (_) {}

    if (!isValid) {
      try {
        _rateLimiter.recordFailure(); 
      } catch (e) {
        if (e is StateError && e.message == 'MAX_ATTEMPTS_REACHED') {
          return AuthFailure.maxAttemptsWipe;
        }
      }
      return _rateLimiter.currentAttempts >= RateLimiter.maxAttempts 
          ? AuthFailure.maxAttemptsWipe 
          : AuthFailure.invalidPin;
    }

    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
          
      if (canAuthenticateWithBiometrics) {
         final didAuthenticate = await _localAuth.authenticate(
            localizedReason: 'Secure Access Required',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
         );
         
         if (!didAuthenticate) {
           return AuthFailure.biometricsFailed;
         }
      }
    } catch (e) {
      return AuthFailure.biometricsFailed;
    }

    _rateLimiter.recordSuccess();
    return null;
  }
}
