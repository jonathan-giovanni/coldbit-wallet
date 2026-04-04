import 'package:coldbit_wallet/core/security/sealed_state.dart';

class RateLimiter {
  static const int maxAttempts = 20;

  late SealedState<int> _failedAttempts;

  RateLimiter() {
    _failedAttempts = SealedState<int>(0);
  }

  Duration recordFailure() {
    _failedAttempts.update((count) => count + 1);
    final currentFails = _failedAttempts.unseal();

    if (currentFails >= maxAttempts) {
      throw StateError('MAX_ATTEMPTS_REACHED');
    }

    return _calculatePenalty(currentFails);
  }

  void recordSuccess() {
    _failedAttempts.update((_) => 0);
  }
  
  int get currentAttempts => _failedAttempts.unseal();

  Duration _calculatePenalty(int attempts) {
    if (attempts <= 3) return const Duration(seconds: 30);
    if (attempts <= 6) return const Duration(minutes: 1);
    if (attempts <= 9) return const Duration(minutes: 3);
    if (attempts <= 12) return const Duration(minutes: 6);
    return const Duration(minutes: 12);
  }
  
  void destroy() {
    _failedAttempts.destroy();
  }
}
