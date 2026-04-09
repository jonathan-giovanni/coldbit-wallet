import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('RateLimiter Async', () {
    late RateLimiter rateLimiter;

    setUp(() {
      rateLimiter = RateLimiter();
    });

    test('attempts < 3 return 0s', () async {
      expect(await rateLimiter.recordFailure(), 0);
      expect(await rateLimiter.recordFailure(), 0);
    });

    test('attempt 3 to 5 jumps to 30s', () async {
      await rateLimiter.recordFailure();
      await rateLimiter.recordFailure();
      expect(await rateLimiter.recordFailure(), 30);
    });

    test('attempt 6 jumps to 1m', () async {
      for (int i = 0; i < 5; i++) {
        await rateLimiter.recordFailure();
      }
      expect(await rateLimiter.recordFailure(), 60);
    });

    test('success clears attempts', () async {
      await rateLimiter.recordFailure();
      expect(await rateLimiter.currentAttempts, 1);
      await rateLimiter.recordSuccess();
      expect(await rateLimiter.currentAttempts, 0);
    });

    test('attempt 20 throws MAX_ATTEMPTS_REACHED', () async {
      for (int i = 0; i < 19; i++) {
        await rateLimiter.recordFailure();
      }
      expect(
        () async => await rateLimiter.recordFailure(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
