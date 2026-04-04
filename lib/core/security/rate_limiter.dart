import 'dart:async';
import 'package:coldbit_wallet/core/security/sealed_state.dart';

/// Implementa la lógica de penalización tras intentos fallidos,
/// protegiendo el contador en la memoria segura de libsodium.
class RateLimiter {
  static const int maxAttempts = 20;

  // Contador protegido estrictamente en memoria (SealedState).
  // Se debe inicializar después del bootstrap de MemGuard.
  late SealedState<int> _failedAttempts;

  RateLimiter() {
    _failedAttempts = SealedState<int>(0);
  }

  /// Registra un intento fallido y devuelve el tiempo de espera resultante.
  /// Si alcanza los 20 intentos, retorna duración infinita/máxima o dispara excepción.
  Duration recordFailure() {
    _failedAttempts.update((count) => count + 1);
    final currentFails = _failedAttempts.unseal();

    if (currentFails >= maxAttempts) {
      // Disparador crítico: El sistema arriba debe atrapar y detonar WIPE
      throw StateError('MAX_ATTEMPTS_REACHED');
    }

    return _calculatePenalty(currentFails);
  }

  /// Limpia los intentos fallidos al tener éxito.
  void recordSuccess() {
    _failedAttempts.update((_) => 0);
  }
  
  /// Devuelve el contador actual seguro.
  int get currentAttempts => _failedAttempts.unseal();

  /// Calcula el bloqueo según las reglas pre-establecidas:
  /// 1-3 -> 30s | 4-6 -> 1m | 7-9 -> 3m | 10-12 -> 6m | 13-19 -> 12m
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
