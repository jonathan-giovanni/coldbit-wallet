import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/presentation/screens/dashboard_screen.dart';
import 'package:coldbit_wallet/presentation/screens/onboarding_screen.dart';
import 'package:coldbit_wallet/presentation/screens/pin_setup_screen.dart';
import 'package:coldbit_wallet/presentation/screens/vault_unlock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
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
      
      final isGoingToOnboarding = state.uri.path == '/onboarding';
      final isGoingToSetup = state.uri.path == '/setup';
      final isGoingToUnlock = state.uri.path == '/unlock';

      switch (authState) {
        case AuthState.uninitialized:
          if (!isGoingToOnboarding && !isGoingToSetup) return '/onboarding';
          break;
        case AuthState.initial:
        case AuthState.error:
          // Unauthenticated but vault exists
          if (!isGoingToUnlock) return '/unlock';
          break;
        case AuthState.authenticated:
          if (isGoingToOnboarding || isGoingToSetup || isGoingToUnlock) {
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
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});
