import 'package:coldbit_wallet/core/crypto/transaction_analyzer.dart';
import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/providers/history_provider.dart';
import 'package:coldbit_wallet/core/providers/wallet_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/presentation/widgets/liquid_glass_card.dart';
import 'package:coldbit_wallet/presentation/widgets/signed_qr_visualizer.dart';
import 'package:coldbit_wallet/presentation/widgets/slide_to_sign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PsbtReviewScreen extends ConsumerStatefulWidget {
  const PsbtReviewScreen({super.key, required this.rawPsbtBase64});
  final String rawPsbtBase64;

  @override
  ConsumerState<PsbtReviewScreen> createState() => _PsbtReviewScreenState();
}

class _PsbtReviewScreenState extends ConsumerState<PsbtReviewScreen> {
  TransactionDetails? _details;
  bool _isAnalyzing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzePayload();
  }

  Future<void> _analyzePayload() async {
    try {
      final details = await TransactionAnalyzer.analyzePsbt(
        widget.rawPsbtBase64,
      );
      setState(() {
        _details = details;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Invalid PSBT or Parse Failure';
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _processSignature() async {
    if (_details == null) return;

    String signedBase64;
    final walletState = ref.read(walletProvider).valueOrNull;
    if (walletState != null) {
      try {
        signedBase64 = await WalletEngine.signPsbtOffline(
          psbtBase64: widget.rawPsbtBase64,
          descriptor: walletState.descriptor,
          network: walletState.network,
        );
      } catch (_) {
        signedBase64 = widget.rawPsbtBase64;
      }
    } else {
      signedBase64 = widget.rawPsbtBase64;
    }

    final record = TransactionRecord(
      txid: _details!.txid,
      amountBtc: _details!.totalAmountBtc,
      feeBtc: _details!.feeBtc,
      timestamp: DateTime.now(),
    );
    await ref.read(historyProvider.notifier).addRecord(record);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignedQrVisualizer(signedPayload: signedBase64),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColdBitTheme.obsidianBlack,
      appBar: AppBar(
        title: const Text('Transaction Review'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _isAnalyzing
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColdBitTheme.goldBitcoin,
                ),
              )
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: ColdBitTheme.errorCrimson.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColdBitTheme.errorCrimson,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ColdBitTheme.errorCrimson.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.shieldAlert,
                              size: 64,
                              color: ColdBitTheme.errorCrimson,
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.1, 1.1),
                            duration: 1.5.seconds,
                            curve: Curves.easeInOutCubic,
                          ),

                      const SizedBox(height: 32),

                      Text(
                        'PAYLOAD REJECTED',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: ColdBitTheme.errorCrimson,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                            ),
                      ).animate().fade().slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      Text(
                        'The scanned physical data does not match a valid Partially Signed Bitcoin Transaction (PSBT). Potential corruption or tampering detected.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColdBitTheme.platinumText,
                          height: 1.5,
                        ),
                      ).animate().fade().slideY(begin: 0.3),

                      const SizedBox(height: 48),

                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColdBitTheme.pureWhiteText,
                          side: const BorderSide(
                            color: ColdBitTheme.brushedMetal,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(LucideIcons.scanLine),
                        label: const Text('RESCAN PAYLOAD'),
                      ).animate().fade(delay: 400.ms),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Approve Output',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColdBitTheme.platinumText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    LiquidGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColdBitTheme.brushedMetal.withValues(
                                    alpha: 0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  LucideIcons.arrowRightCircle,
                                  color: ColdBitTheme.goldBitcoin,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount to Send',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: ColdBitTheme.platinumText,
                                        ),
                                  ),
                                  Text(
                                    '${_details!.totalAmountBtc.toStringAsFixed(8)} BTC',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'monospace',
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(color: ColdBitTheme.darkGraphite),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Network Fee',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: ColdBitTheme.platinumText,
                                    ),
                              ),
                              Text(
                                '${_details!.feeBtc.toStringAsFixed(8)} BTC',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColdBitTheme.errorCrimson,
                                      fontFamily: 'monospace',
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TxID Hash',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: ColdBitTheme.platinumText,
                                    ),
                              ),
                              Text(
                                '${_details!.txid.substring(0, 8)}...${_details!.txid.substring(_details!.txid.length - 8)}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      fontFamily: 'monospace',
                                      color: ColdBitTheme.pureWhiteText
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fade().slideY(begin: 0.1),

                    const Spacer(),

                    SlideToSign(
                      onSign: _processSignature,
                    ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}
