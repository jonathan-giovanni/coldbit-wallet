import 'package:coldbit_wallet/core/config/vault_config.dart';
import 'package:coldbit_wallet/core/security/secure_enclave.dart';

class RateLimiter {
  static int get maxAttempts => VaultConfig.maxAuthAttempts;

  Future<int> _getAttempts() async {
    final str = await SecureEnclave.read('coldbit_failed_attempts');
    return int.tryParse(str ?? '0') ?? 0;
  }

  Future<void> _setAttempts(int count) async {
    await SecureEnclave.write('coldbit_failed_attempts', count.toString());
  }

  Future<void> _setLockoutTime(DateTime time) async {
    await SecureEnclave.write('coldbit_lockout_time', time.toIso8601String());
  }

  Future<DateTime?> _getLockoutTime() async {
    final str = await SecureEnclave.read('coldbit_lockout_time');
    if (str == null || str.isEmpty) return null;
    return DateTime.tryParse(str);
  }

  Future<int> checkWaitTimeRemaining() async {
    final lockout = await _getLockoutTime();
    if (lockout == null) return 0;

    final diff = lockout.difference(DateTime.now());
    if (diff.isNegative) return 0;
    return diff.inSeconds;
  }

  Future<int> recordFailure() async {
    var count = await _getAttempts();
    count += 1;
    await _setAttempts(count);

    if (count >= maxAttempts) {
      throw StateError('MAX_ATTEMPTS_REACHED');
    }

    final penalty = _calculatePenalty(count);
    if (penalty.inSeconds > 0) {
      final blockUntil = DateTime.now().add(penalty);
      await _setLockoutTime(blockUntil);
    }

    return penalty.inSeconds;
  }

  Future<void> recordSuccess() async {
    await _setAttempts(0);
    await SecureEnclave.write('coldbit_lockout_time', '');
  }

  Future<int> get currentAttempts async => await _getAttempts();

  Duration _calculatePenalty(int attempts) {
    if (attempts < 3) return Duration.zero;
    if (attempts <= 5) return const Duration(seconds: 30);
    if (attempts <= 8) return const Duration(minutes: 1);
    if (attempts <= 11) return const Duration(minutes: 3);
    if (attempts <= 14) return const Duration(minutes: 6);
    return const Duration(minutes: 12);
  }
}
