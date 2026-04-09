import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BiometricOptinScreen extends ConsumerStatefulWidget {
  const BiometricOptinScreen({super.key});

  @override
  ConsumerState<BiometricOptinScreen> createState() =>
      _BiometricOptinScreenState();
}

class _BiometricOptinScreenState extends ConsumerState<BiometricOptinScreen> {
  bool _isLoading = false;

  Future<void> _handleOptIn() async {
    final reason = AppLocalizations.of(context)!.biometricOptinReason;
    setState(() => _isLoading = true);

    final auth = LocalAuthentication();
    final canCheck =
        await auth.canCheckBiometrics || await auth.isDeviceSupported();

    if (canCheck) {
      try {
        final didAuth = await auth.authenticate(
          localizedReason: reason,
          biometricOnly: true,
        );
        if (didAuth) {
          await ColdBitSettings.completeBiometricSetup(true);
          if (!mounted) return;
          ref.invalidate(biometricSetupCompletedProvider);
          ref.invalidate(biometricsEnabledProvider);
          context.go('/dashboard');
          return;
        }
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _handleSkip() async {
    await ColdBitSettings.completeBiometricSetup(false);
    if (!mounted) return;
    ref.invalidate(biometricSetupCompletedProvider);
    ref.invalidate(biometricsEnabledProvider);
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: ColdBitTheme.brushedMetal.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.scanFace,
                    size: 80,
                    color: ColdBitTheme.goldBitcoin,
                  ),
                ),
              )
              .animate()
              .scale(begin: const Offset(0.5, 0.5), duration: 800.ms, curve: Curves.easeOutBack)
              .shimmer(delay: 800.ms, duration: 2.seconds),

              const SizedBox(height: 48),

              Text(
                loc.biometricOptinTitle.toUpperCase(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.2),

              const SizedBox(height: 16),

              Text(
                loc.biometricOptinDesc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 400.ms).slideY(begin: 0.2),

              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColdBitActionButton(
                    label: loc.biometricOptinConfirmBtn,
                    icon: LucideIcons.checkCircle,
                    isLoading: _isLoading,
                    onPressed: _handleOptIn,
                  ).animate().fade(delay: 600.ms).slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: _handleSkip,
                    child: Text(
                      loc.biometricOptinSkipBtn,
                      style: const TextStyle(
                        color: ColdBitTheme.platinumText,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ).animate().fade(delay: 800.ms),
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
