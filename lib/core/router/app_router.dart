import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/presentation/screens/about_screen.dart';
import 'package:coldbit_wallet/presentation/screens/biometric_optin_screen.dart';
import 'package:coldbit_wallet/presentation/screens/dashboard_screen.dart';
import 'package:coldbit_wallet/presentation/screens/onboarding_screen.dart';
import 'package:coldbit_wallet/presentation/screens/pin_setup_screen.dart';
import 'package:coldbit_wallet/presentation/screens/receive_screen.dart';
import 'package:coldbit_wallet/presentation/screens/seed_backup_screen.dart';
import 'package:coldbit_wallet/presentation/screens/seed_verify_screen.dart';
import 'package:coldbit_wallet/presentation/screens/settings_screen.dart';
import 'package:coldbit_wallet/presentation/screens/vault_unlock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
    _ref.listen<AsyncValue<bool>>(
      biometricSetupCompletedProvider,
      (_, _) => notifyListeners(),
    );
  }
  final Ref _ref;
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final biometricsSetupCompletedAsync = ref.read(
        biometricSetupCompletedProvider,
      );

      final currentPath = state.uri.path;
      final isGoingToOnboarding = currentPath == '/onboarding';
      final isGoingToSetup = currentPath == '/setup';
      final isGoingToUnlock = currentPath == '/unlock';
      final isGoingToSeedBackup = currentPath == '/seed-backup';
      final isGoingToSeedVerify = currentPath == '/seed-verify';
      final isGoingToBiometricSetup = currentPath == '/biometric-setup';

      switch (authState) {
        case AuthState.uninitialized:
          if (!isGoingToOnboarding && !isGoingToSetup) return '/onboarding';
          break;
        case AuthState.seedPending:
          if (!isGoingToSeedBackup && !isGoingToSeedVerify) {
            return '/seed-backup';
          }
          break;
        case AuthState.initial:
        case AuthState.error:
          if (!isGoingToUnlock) return '/unlock';
          break;
        case AuthState.authenticated:
          if (biometricsSetupCompletedAsync is AsyncData) {
            final setupCompleted = biometricsSetupCompletedAsync.value ?? false;
            if (!setupCompleted && !isGoingToBiometricSetup) {
              return '/biometric-setup';
            }
          }
          if (isGoingToOnboarding ||
              isGoingToSetup ||
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
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/seed-backup',
        builder: (context, state) => const SeedBackupScreen(),
      ),
      GoRoute(
        path: '/seed-verify',
        builder: (context, state) => const SeedVerifyScreen(),
      ),
      GoRoute(
        path: '/unlock',
        builder: (context, state) => const VaultUnlockScreen(),
      ),
      GoRoute(
        path: '/biometric-setup',
        builder: (context, state) => const BiometricOptinScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(
        path: '/receive',
        builder: (context, state) => const ReceiveScreen(),
      ),
    ],
  );
});
