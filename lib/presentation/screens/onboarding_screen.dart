import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient Glow Background
          Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.15),
                        blurRadius: 100,
                        spreadRadius: 50,
                      ),
                    ],
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 4.seconds,
              ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Shield Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColdBitTheme.goldBitcoin.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.shieldAlert,
                        size: 64,
                        color: ColdBitTheme.goldBitcoin,
                      ),
                    ),
                  ).animate().scale(
                    delay: 200.ms,
                    begin: const Offset(0, 0),
                    curve: Curves.easeOutBack,
                    duration: 600.ms,
                  ),

                  const SizedBox(height: 48),

                  Text(
                    'Military Grade\nCold Storage',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fade(delay: 400.ms).slideY(begin: 0.5),

                  const SizedBox(height: 16),

                  Text(
                    'Your device will now operate in total isolation. No telemetry. No connections. Completely Air-Gapped.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColdBitTheme.platinumText,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fade(delay: 600.ms).slideY(begin: 0.5),

                  const Spacer(flex: 2),

                  ColdBitActionButton(
                        label: 'Initialize Vault',
                        icon: LucideIcons.lock,
                        onPressed: () {
                          context.push('/setup');
                        },
                      )
                      .animate()
                      .fade(delay: 800.ms)
                      .shimmer(duration: 2.seconds, color: Colors.white24),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
