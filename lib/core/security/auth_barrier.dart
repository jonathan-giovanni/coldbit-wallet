import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:local_auth/local_auth.dart';

enum AuthFailure { inactive, invalidPin, timeoutBlock, biometricsFailed, maxAttemptsWipe }

class AuthBarrier {

  AuthBarrier(this._rateLimiter);
  static const String _pinHashKey = 'coldbit_pin_hash';
  final LocalAuthentication _localAuth = LocalAuthentication();
  final RateLimiter _rateLimiter;

  static Future<void> registerPin(String pin) async {
    final sodium = MemGuard.sodium;
    
    final auth = LocalAuthentication();
    final canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
    if (!canCheck) {
      throw StateError('BIOMETRICS_UNAVAILABLE');
    }

    final didAuth = await auth.authenticate(
      localizedReason: 'Secure Vault Registration',
      biometricOnly: true,
    );
    
    if (!didAuth) {
      throw StateError('BIOMETRICS_DENIED');
    }

    try {
      final String hashStr = sodium.crypto.pwhash.str(
        password: pin,
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
    
    bool isValid = false;
    try {
      isValid = sodium.crypto.pwhash.strVerify(
        passwordHash: savedHash,
        password: attemptPin,
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

    // MANDATORY BIOMETRICS (DUAL AUTH)
    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
          
      if (!canAuthenticateWithBiometrics) return AuthFailure.biometricsFailed;
      
      final didAuthenticate = await _localAuth.authenticate(
         localizedReason: 'Biological Authorization Required',
         biometricOnly: true,
      );
      
      if (!didAuthenticate) {
        return AuthFailure.biometricsFailed;
      }
    } catch (e) {
      return AuthFailure.biometricsFailed;
    }

    _rateLimiter.recordSuccess();
    return null;
  }
}
