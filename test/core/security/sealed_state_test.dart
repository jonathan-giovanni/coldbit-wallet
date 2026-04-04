import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/sealed_state.dart';

void main() {
  setUpAll(() async {
    // Initialize libsodium for tests
    await MemGuard.init();
  });

  group('SealedState<T>', () {
    test('successfully seals and unseals an integer', () {
      final state = SealedState<int>(42);
      expect(state.unseal(), 42);
    });

    test('successfully seals and unseals a boolean', () {
      final state = SealedState<bool>(true);
      expect(state.unseal(), true);
      
      final stateFalse = SealedState<bool>(false);
      expect(stateFalse.unseal(), false);
    });

    test('successfully seals and unseals a String', () {
      final state = SealedState<String>('SuperSecretData');
      expect(state.unseal(), 'SuperSecretData');
    });

    test('successfully MUTATES the state securely', () {
      final state = SealedState<int>(10);
      
      state.update((current) => current + 5);
      
      expect(state.unseal(), 15);
    });

    test('throws error if state is destroyed', () {
      final state = SealedState<String>('WillBeDestroyed');
      expect(state.unseal(), 'WillBeDestroyed');
      
      state.destroy();
      
      expect(
        () => state.unseal(),
        throwsA(isA<StateError>()),
      );
    });

    // In a real isolated memory environment it's hard to test the MAC failure organically
    // since the ciphertext is private and we shouldn't expose it.
    // We would need reflection or a mock to alter ciphertext. But we guarantee
    // that if it is altered, `openEasy` throws, caught as TamperDetectedException.
  });
}
