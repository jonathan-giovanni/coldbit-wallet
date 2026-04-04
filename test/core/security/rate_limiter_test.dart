import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await MemGuard.init();
  });

  group('RateLimiter', () {
    late RateLimiter rateLimiter;

    setUp(() {
      rateLimiter = RateLimiter();
    });
    
    tearDown(() {
      rateLimiter.destroy();
    });

    test('attempts 1 to 3 return 30s', () {
      expect(rateLimiter.recordFailure().inSeconds, 30);
      expect(rateLimiter.recordFailure().inSeconds, 30);
      expect(rateLimiter.recordFailure().inSeconds, 30);
    });

    test('attempt 4 jumps to 1m', () {
      rateLimiter.recordFailure();
      rateLimiter.recordFailure();
      rateLimiter.recordFailure();
      expect(rateLimiter.recordFailure().inMinutes, 1);
    });

    test('attempt 13 jumps to 12m', () {
      for (int i = 0; i < 12; i++) {
        rateLimiter.recordFailure();
      }
      expect(rateLimiter.recordFailure().inMinutes, 12);
      expect(rateLimiter.currentAttempts, 13);
    });

    test('success clears attempts', () {
      rateLimiter.recordFailure();
      expect(rateLimiter.currentAttempts, 1);
      rateLimiter.recordSuccess();
      expect(rateLimiter.currentAttempts, 0);
    });

    test('attempt 20 throws MAX_ATTEMPTS_REACHED', () {
      for (int i = 0; i < 19; i++) {
        rateLimiter.recordFailure();
      }
      expect(() => rateLimiter.recordFailure(), throwsA(isA<StateError>()));
    });
  });
}
