import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';
import 'package:local_auth/local_auth.dart';

sealed class AuthResult {}
class AuthSuccess extends AuthResult {}
class AuthInvalidPin extends AuthResult {}
class AuthBiometricsFailed extends AuthResult {}
class AuthTimeoutBlock extends AuthResult {
  AuthTimeoutBlock(this.secondsRemaining);
  final int secondsRemaining;
}
class AuthMaxAttemptsWiped extends AuthResult {}
class AuthInactive extends AuthResult {}

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

  Future<AuthResult> authenticate(String attemptPin) async {
    final waitRemaining = await _rateLimiter.checkWaitTimeRemaining();
    if (waitRemaining > 0) return AuthTimeoutBlock(waitRemaining);

    final savedHash = await SecureEnclave.read(_pinHashKey);
    if (savedHash == null) return AuthInactive();

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
        final timeoutSecs = await _rateLimiter.recordFailure(); 
        if (timeoutSecs > 0) return AuthTimeoutBlock(timeoutSecs);
        return AuthInvalidPin();
      } catch (e) {
        if (e is StateError && e.message == 'MAX_ATTEMPTS_REACHED') {
          await SecureEnclave.wipe();
          return AuthMaxAttemptsWiped();
        }
      }
      final fails = await _rateLimiter.currentAttempts;
      if (fails >= RateLimiter.maxAttempts) {
        await SecureEnclave.wipe();
        return AuthMaxAttemptsWiped();
      }
      return AuthInvalidPin();
    }

    // MANDATORY BIOMETRICS REMOVED FROM PIN FALLBACK
    await _rateLimiter.recordSuccess();
    return AuthSuccess();
  }

  Future<bool> authenticateBiometricsOnly() async {
    final waitRemaining = await _rateLimiter.checkWaitTimeRemaining();
    if (waitRemaining > 0) return false;

    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
          
      if (!canAuthenticateWithBiometrics) return false;
      
      final didAuthenticate = await _localAuth.authenticate(
         localizedReason: 'Biometric authorization required to bypass PIN',
         biometricOnly: true,
      );
      
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
