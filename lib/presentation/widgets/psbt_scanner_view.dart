import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PsbtScannerView extends StatefulWidget {
  const PsbtScannerView({super.key, required this.onDetect});
  final Function(String output) onDetect;

  @override
  State<PsbtScannerView> createState() => _PsbtScannerViewState();
}

class _PsbtScannerViewState extends State<PsbtScannerView> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _isProcessing = true);
        widget.onDetect(barcode.rawValue!);
        _controller.stop();
        break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColdBitTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('Optical Air-Gap Scanner'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
            errorBuilder: (BuildContext context, MobileScannerException error) {
              return Center(
                child: Text(
                  'Hardware Camera Access Required Offline',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColdBitTheme.errorCrimson,
                      ),
                ),
              );
            },
          ),
          
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              ColdBitTheme.darkGraphite.withValues(alpha: 0.8),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black, 
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: ColdBitTheme.goldBitcoin, width: 2),
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: ColdBitTheme.glowShadow,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 2.seconds),

          if (_isProcessing)
            Container(
              color: ColdBitTheme.obsidianBlack.withValues(alpha: 0.9),
              child: const Center(
                child: CircularProgressIndicator(color: ColdBitTheme.goldBitcoin),
              ),
            ).animate().fade(duration: 200.ms),
        ],
      ),
    );
  }
}
