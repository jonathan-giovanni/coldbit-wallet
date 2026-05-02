import 'package:coldbit_wallet/core/providers/wallet_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  bool _copied = false;

  void _copyAddress(String address) {
    Clipboard.setData(ClipboardData(text: address));
    HapticFeedback.mediumImpact();
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.receiveTitle),
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: ColdBitTheme.goldBitcoin,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: walletAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: ColdBitTheme.goldBitcoin),
          ),
          error: (_, _) => Center(
            child: Text(
              loc.receiveError,
              style: const TextStyle(color: ColdBitTheme.errorCrimson),
            ),
          ),
          data: (wallet) {
            if (wallet == null) {
              return Center(
                child: Text(
                  loc.receiveNoWallet,
                  style: const TextStyle(color: ColdBitTheme.platinumText),
                ),
              );
            }

            final address = wallet.receiveAddress;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    loc.receiveDesc,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColdBitTheme.platinumText,
                      height: 1.5,
                    ),
                  ).animate().fade(delay: 100.ms),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ColdBitTheme.goldBitcoin.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: address,
                      version: QrVersions.auto,
                      size: 220,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: ColdBitTheme.obsidianBlack,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: ColdBitTheme.obsidianBlack,
                      ),
                    ),
                  ).animate().fade().scale(
                    begin: const Offset(0.9, 0.9),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: ColdBitTheme.darkGraphite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            address,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.8,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: AnimatedSwitcher(
                            duration: 200.ms,
                            child: _copied
                                ? const Icon(
                                    LucideIcons.checkCircle,
                                    key: ValueKey('check'),
                                    color: ColdBitTheme.successGreen,
                                    size: 20,
                                  )
                                : const Icon(
                                    LucideIcons.copy,
                                    key: ValueKey('copy'),
                                    color: ColdBitTheme.goldBitcoin,
                                    size: 20,
                                  ),
                          ),
                          onPressed: () => _copyAddress(address),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
                  const SizedBox(height: 16),
                  Text(
                    wallet.receivePath,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ColdBitTheme.goldBitcoin,
                      fontFamily: 'monospace',
                    ),
                  ).animate().fade(delay: 250.ms),
                  const SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: _copied ? 1.0 : 0.0,
                    duration: 200.ms,
                    child: Text(
                      loc.receiveCopied,
                      style: const TextStyle(
                        color: ColdBitTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.shieldCheck,
                          color: ColdBitTheme.goldBitcoin,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            loc.receiveOfflineNote,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: ColdBitTheme.platinumText,
                                  height: 1.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 400.ms),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
