import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/presentation/screens/about_screen.dart';
import 'package:coldbit_wallet/presentation/screens/biometric_optin_screen.dart';
import 'package:coldbit_wallet/presentation/screens/dashboard_screen.dart';
import 'package:coldbit_wallet/presentation/screens/onboarding_screen.dart';
import 'package:coldbit_wallet/presentation/screens/pin_setup_screen.dart';
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

      final isGoingToOnboarding = state.uri.path == '/onboarding';
      final isGoingToSetup = state.uri.path == '/setup';
      final isGoingToUnlock = state.uri.path == '/unlock';
      final isGoingToBiometricSetup = state.uri.path == '/biometric-setup';

      switch (authState) {
        case AuthState.uninitialized:
          if (!isGoingToOnboarding && !isGoingToSetup) return '/onboarding';
          break;
        case AuthState.initial:
        case AuthState.error:
          if (!isGoingToUnlock) return '/unlock';
          break;
        case AuthState.authenticated:
          // Check biometrics setup
          if (biometricsSetupCompletedAsync is AsyncData) {
            final setupCompleted = biometricsSetupCompletedAsync.value ?? false;
            if (!setupCompleted && !isGoingToBiometricSetup) {
              return '/biometric-setup';
            }
          }
          if (isGoingToOnboarding || isGoingToSetup || isGoingToUnlock) {
            if (biometricsSetupCompletedAsync is AsyncData) {
              final val = biometricsSetupCompletedAsync.value ?? false;
              if (!val) return '/biometric-setup';
            }
            return '/dashboard';
          }
          break;
        case AuthState.loading:
          break; // Permite espera UI
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
    ],
  );
});
