import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:coldbit_wallet/presentation/widgets/liquid_glass_card.dart';
import 'package:coldbit_wallet/presentation/widgets/psbt_scanner_view.dart';
import 'package:coldbit_wallet/presentation/widgets/signed_qr_visualizer.dart';
import 'package:coldbit_wallet/presentation/widgets/status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Subtle Top Gradient
          Positioned(
            top: -150,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColdBitTheme.brushedMetal.withValues(alpha: 0.5),
                    blurRadius: 120,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColdBitTheme.darkGraphite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(LucideIcons.wallet, size: 20, color: ColdBitTheme.pureWhiteText),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Vault',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ],
                      ),
                      const StatusPill(label: 'Air-Gapped'),
                    ],
                  ).animate().fade().slideY(begin: -0.2),
                  
                  const SizedBox(height: 32),
                  
                  LiquidGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Master Fingerprint',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColdBitTheme.platinumText,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Icon(LucideIcons.fingerprint, size: 16, color: ColdBitTheme.goldBitcoin),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A1B2C3D4',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w800,
                                letterSpacing: 4.0,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "m/84'/0'/0'",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: ColdBitTheme.goldBitcoin,
                                      fontFamily: 'monospace',
                                    ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Native SegWit',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColdBitTheme.platinumText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 200.ms).slideX(begin: 0.1),
                  
                  const Spacer(),
                  
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColdBitTheme.darkGraphite.withValues(alpha: 0.8),
                            border: Border.all(color: ColdBitTheme.obsidianBlack, width: 4),
                            boxShadow: ColdBitTheme.ambientShadow,
                          ),
                          child: const Icon(LucideIcons.qrCode, size: 32, color: ColdBitTheme.platinumText),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                         .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds),
                        
                        const SizedBox(height: 32),
                        
                        Text(
                          'Ready to Sign',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan a Partially Signed Bitcoin Transaction (PSBT) to authorize it offline within the enclave.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColdBitTheme.platinumText,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                  
                  const Spacer(),
                  
                  ColdBitActionButton(
                    label: 'Scan PSBT Ticket',
                    icon: LucideIcons.scanLine,
                    onPressed: () async {
                      final output = await Navigator.of(context).push<String>(
                        MaterialPageRoute(
                          builder: (context) => PsbtScannerView(
                            onDetect: (data) => data,
                          ),
                        ),
                      );
                      
                      if (output != null && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignedQrVisualizer(
                              signedPayload: 'MOCK_SIGNED_PSBT_$output',
                            ),
                          ),
                        );
                      }
                    },
                  ).animate().fade(delay: 600.ms).slideY(begin: 0.2),
                  
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
