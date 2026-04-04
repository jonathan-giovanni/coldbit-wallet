import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/sealed_state.dart';

void main() {
  setUpAll(() async {
    await MemGuard.init();
  });

  group('SealedState<T>', () {
    test('seals and unseals int', () {
      final state = SealedState<int>(42);
      expect(state.unseal(), 42);
    });

    test('seals and unseals bool', () {
      final state = SealedState<bool>(true);
      expect(state.unseal(), true);
      
      final stateFalse = SealedState<bool>(false);
      expect(stateFalse.unseal(), false);
    });

    test('seals and unseals String', () {
      final state = SealedState<String>('SuperSecretData');
      expect(state.unseal(), 'SuperSecretData');
    });

    test('mutates securely', () {
      final state = SealedState<int>(10);
      state.update((current) => current + 5);
      expect(state.unseal(), 15);
    });

    test('throws StateError when destroyed', () {
      final state = SealedState<String>('WillBeDestroyed');
      expect(state.unseal(), 'WillBeDestroyed');
      state.destroy();
      expect(() => state.unseal(), throwsA(isA<StateError>()));
    });
  });
}
