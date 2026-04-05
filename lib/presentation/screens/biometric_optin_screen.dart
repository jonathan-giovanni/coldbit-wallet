import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BiometricOptinScreen extends ConsumerStatefulWidget {
  const BiometricOptinScreen({super.key});

  @override
  ConsumerState<BiometricOptinScreen> createState() => _BiometricOptinScreenState();
}

class _BiometricOptinScreenState extends ConsumerState<BiometricOptinScreen> {
  bool _isLoading = false;

  Future<void> _handleOptIn() async {
    setState(() => _isLoading = true);
    
    final auth = LocalAuthentication();
    final canCheck = await auth.canCheckBiometrics || await auth.isDeviceSupported();
    
    if (canCheck) {
      try {
        final didAuth = await auth.authenticate(
          localizedReason: 'Enable Biometrics for ColdBit Vault',
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(LucideIcons.scanFace, size: 64, color: ColdBitTheme.goldBitcoin)
                  .animate().fade(duration: 500.ms).scale(begin: const Offset(0.5, 0.5)),
              const SizedBox(height: 32),
              Text(
                'Biometric Defense',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColdBitTheme.pureWhiteText,
                    ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 200.ms),
              const SizedBox(height: 16),
              Text(
                'Accelerate your Vault access by linking your biological signature. This feature is completely optional and your Face ID/Touch ID never leaves your physical device.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColdBitTheme.platinumText,
                      height: 1.6,
                    ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 300.ms),
              const Spacer(),
              
              if (_isLoading)
                 const Center(child: CircularProgressIndicator(color: ColdBitTheme.goldBitcoin))
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _handleSkip,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: ColdBitTheme.platinumText,
                        ),
                        child: const Text('Omitir', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleOptIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColdBitTheme.goldBitcoin,
                          foregroundColor: ColdBitTheme.obsidianBlack,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Confirmar', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ).animate().fade(delay: 500.ms).slideY(begin: 0.5),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
