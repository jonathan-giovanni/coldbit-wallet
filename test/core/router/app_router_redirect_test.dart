import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/router/auth_redirect_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveAuthRedirect', () {
    const biometricsDone = AsyncData<bool>(true);

    test('fresh installs enter the intro onboarding flow', () {
      expect(
        resolveAuthRedirect(
          authState: AuthState.uninitialized,
          biometricsSetupCompletedAsync: biometricsDone,
          currentPath: '/dashboard',
        ),
        '/intro',
      );
      expect(
        resolveAuthRedirect(
          authState: AuthState.uninitialized,
          biometricsSetupCompletedAsync: biometricsDone,
          currentPath: '/intro',
        ),
        isNull,
      );
    });

    test('existing locked vaults can still open setup onboarding routes', () {
      for (final path in [
        '/intro',
        '/security-briefing',
        '/vault-mode',
        '/mnemonic-length',
        '/backup-discipline',
        '/setup',
        '/recover',
      ]) {
        expect(
          resolveAuthRedirect(
            authState: AuthState.initial,
            biometricsSetupCompletedAsync: biometricsDone,
            currentPath: path,
          ),
          isNull,
          reason: '$path must remain visible from the unlock screen',
        );
      }
    });

    test('existing locked vaults still protect private app routes', () {
      expect(
        resolveAuthRedirect(
          authState: AuthState.initial,
          biometricsSetupCompletedAsync: biometricsDone,
          currentPath: '/dashboard',
        ),
        '/unlock',
      );
    });

    test('seed pending state stays pinned to backup verification', () {
      expect(
        resolveAuthRedirect(
          authState: AuthState.seedPending,
          biometricsSetupCompletedAsync: biometricsDone,
          currentPath: '/dashboard',
        ),
        '/seed-backup',
      );
      expect(
        resolveAuthRedirect(
          authState: AuthState.seedPending,
          biometricsSetupCompletedAsync: biometricsDone,
          currentPath: '/seed-verify',
        ),
        isNull,
      );
    });
  });
}
