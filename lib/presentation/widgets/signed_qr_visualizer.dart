import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignedQrVisualizer extends StatefulWidget {
  const SignedQrVisualizer({super.key, required this.signedPayload});
  final String signedPayload;

  @override
  State<SignedQrVisualizer> createState() => _SignedQrVisualizerState();
}

class _SignedQrVisualizerState extends State<SignedQrVisualizer> {
  // If the Payload exceeds typical Base64 limits reliably readable by normal cameras
  // we could split it here. For now we will render a massive dense QR with high ECC.
  // We use QrImageView for qr_flutter v4.1.0+

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColdBitTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('Signed Payload Ready'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              'Transmitting to Watch-Only',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ).animate().fade().slideY(begin: -0.2),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Text(
                'Scan this pattern with your connected device to broadcast the transaction.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ).animate().fade(delay: 200.ms),
            ),
            const Spacer(),

            // Render Dense QR Payload
            Center(
              child:
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColdBitTheme.pureWhiteText,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: ColdBitTheme.glowShadow,
                    ),
                    child: QrImageView(
                      data: widget.signedPayload,
                      version: QrVersions.auto,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                      size: 280.0,
                      backgroundColor: ColdBitTheme.pureWhiteText,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: ColdBitTheme.obsidianBlack,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: ColdBitTheme.obsidianBlack,
                      ),
                    ),
                  ).animate().scale(
                    delay: 400.ms,
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.easeOutBack,
                  ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ColdBitActionButton(
                label: 'Finish',
                icon: LucideIcons.checkCircle2,
                isPrimary: false,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ).animate().fade(delay: 600.ms),
            ),
          ],
        ),
      ),
    );
  }
}
