import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/core/router/auth_redirect_policy.dart';
import 'package:coldbit_wallet/presentation/screens/about_screen.dart';
import 'package:coldbit_wallet/presentation/screens/backup_discipline_screen.dart';
import 'package:coldbit_wallet/presentation/screens/biometric_optin_screen.dart';
import 'package:coldbit_wallet/presentation/screens/dashboard_screen.dart';
import 'package:coldbit_wallet/presentation/screens/intro_screen.dart';
import 'package:coldbit_wallet/presentation/screens/mnemonic_length_screen.dart';
import 'package:coldbit_wallet/presentation/screens/onboarding_screen.dart';
import 'package:coldbit_wallet/presentation/screens/pin_setup_screen.dart';
import 'package:coldbit_wallet/presentation/screens/receive_screen.dart';
import 'package:coldbit_wallet/presentation/screens/security_briefing_screen.dart';
import 'package:coldbit_wallet/presentation/screens/seed_backup_screen.dart';
import 'package:coldbit_wallet/presentation/screens/seed_recovery_screen.dart';
import 'package:coldbit_wallet/presentation/screens/seed_verify_screen.dart';
import 'package:coldbit_wallet/presentation/screens/settings_screen.dart';
import 'package:coldbit_wallet/presentation/screens/vault_mode_screen.dart';
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
    initialLocation: '/intro',
    redirect: (context, state) {
      return resolveAuthRedirect(
        authState: ref.read(authProvider),
        biometricsSetupCompletedAsync: ref.read(
          biometricSetupCompletedProvider,
        ),
        currentPath: state.uri.path,
      );
    },
    routes: [
      _route('/intro', const IntroScreen()),
      _route('/onboarding', const OnboardingScreen()),
      _route('/security-briefing', const SecurityBriefingScreen()),
      _route('/vault-mode', const VaultModeScreen()),
      _route('/mnemonic-length', const MnemonicLengthScreen()),
      _route('/backup-discipline', const BackupDisciplineScreen()),
      _route('/setup', const PinSetupScreen()),
      _route('/seed-backup', const SeedBackupScreen()),
      _route('/seed-verify', const SeedVerifyScreen()),
      _route('/recover', const SeedRecoveryScreen()),
      _route('/unlock', const VaultUnlockScreen()),
      _route('/biometric-setup', const BiometricOptinScreen()),
      _route('/dashboard', const DashboardScreen()),
      _route('/settings', const SettingsScreen()),
      _route('/about', const AboutScreen()),
      _route('/receive', const ReceiveScreen()),
    ],
  );
});

GoRoute _route(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(fade),
            child: child,
          ),
        );
      },
    ),
  );
}
