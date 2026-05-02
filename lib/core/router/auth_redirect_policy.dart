import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String? resolveAuthRedirect({
  required AuthState authState,
  required AsyncValue<bool> biometricsSetupCompletedAsync,
  required String currentPath,
}) {
  final isGoingToIntro = currentPath == '/intro';
  final isGoingToOnboarding = currentPath == '/onboarding';
  final isGoingToSecurityBriefing = currentPath == '/security-briefing';
  final isGoingToVaultMode = currentPath == '/vault-mode';
  final isGoingToMnemonicLength = currentPath == '/mnemonic-length';
  final isGoingToBackupDiscipline = currentPath == '/backup-discipline';
  final isGoingToSetup = currentPath == '/setup';
  final isGoingToUnlock = currentPath == '/unlock';
  final isGoingToSeedBackup = currentPath == '/seed-backup';
  final isGoingToSeedVerify = currentPath == '/seed-verify';
  final isGoingToRecover = currentPath == '/recover';
  final isGoingToBiometricSetup = currentPath == '/biometric-setup';

  final isOnboardingPath =
      isGoingToIntro ||
      isGoingToOnboarding ||
      isGoingToSecurityBriefing ||
      isGoingToVaultMode ||
      isGoingToMnemonicLength ||
      isGoingToBackupDiscipline ||
      isGoingToSetup ||
      isGoingToRecover;

  switch (authState) {
    case AuthState.uninitialized:
      if (!isOnboardingPath) return '/intro';
      break;
    case AuthState.seedPending:
      if (!isGoingToSeedBackup && !isGoingToSeedVerify) {
        return '/seed-backup';
      }
      break;
    case AuthState.initial:
    case AuthState.error:
      if (!isGoingToUnlock && !isOnboardingPath) return '/unlock';
      break;
    case AuthState.authenticated:
      if (biometricsSetupCompletedAsync is AsyncData) {
        final setupCompleted = biometricsSetupCompletedAsync.value ?? false;
        if (!setupCompleted && !isGoingToBiometricSetup) {
          return '/biometric-setup';
        }
      }
      if (isOnboardingPath ||
          isGoingToUnlock ||
          isGoingToSeedBackup ||
          isGoingToSeedVerify) {
        if (biometricsSetupCompletedAsync is AsyncData) {
          final val = biometricsSetupCompletedAsync.value ?? false;
          if (!val) return '/biometric-setup';
        }
        return '/dashboard';
      }
      break;
    case AuthState.loading:
      break;
  }
  return null;
}
