import 'package:flutter_test/flutter_test.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';

void main() {
  setUpAll(() async {
    await MemGuard.init();
  });

  group('RateLimiter Exponencial', () {
    late RateLimiter rateLimiter;

    setUp(() {
      rateLimiter = RateLimiter();
    });
    
    tearDown(() {
      rateLimiter.destroy();
    });

    test('intentos 1 a 3 devuelven penalización de 30 segundos', () {
      expect(rateLimiter.recordFailure().inSeconds, 30); // 1
      expect(rateLimiter.recordFailure().inSeconds, 30); // 2
      expect(rateLimiter.recordFailure().inSeconds, 30); // 3
    });

    test('intento 4 salta a penalización de 1 minuto', () {
      rateLimiter.recordFailure(); // 1
      rateLimiter.recordFailure(); // 2
      rateLimiter.recordFailure(); // 3
      final penalty = rateLimiter.recordFailure(); // 4
      
      expect(penalty.inMinutes, 1);
    });

    test('intento 13 salta a penalización máxima de 12 minutos', () {
      for (int i = 0; i < 12; i++) {
        rateLimiter.recordFailure();
      }
      final penalty = rateLimiter.recordFailure(); // 13
      
      expect(penalty.inMinutes, 12);
      expect(rateLimiter.currentAttempts, 13);
    });

    test('éxito blanquea el contador', () {
      rateLimiter.recordFailure(); // 1
      expect(rateLimiter.currentAttempts, 1);
      
      rateLimiter.recordSuccess();
      expect(rateLimiter.currentAttempts, 0);
    });

    test('intento 20 lanza excepción de MÁXIMO MAX_ATTEMPTS_REACHED para WIPE', () {
      for (int i = 0; i < 19; i++) {
        rateLimiter.recordFailure();
      }
      
      expect(() => rateLimiter.recordFailure(), throwsA(isA<StateError>()));
    });
  });
}
