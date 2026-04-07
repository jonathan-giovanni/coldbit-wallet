import 'package:coldbit_wallet/core/config/vault_config.dart';
import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/core/security/auth_barrier.dart';
import 'package:coldbit_wallet/core/security/rate_limiter.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AuthChallengeSheet extends ConsumerStatefulWidget {
  const AuthChallengeSheet({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuthChallengeSheet(),
    );
    return result ?? false;
  }

  @override
  ConsumerState<AuthChallengeSheet> createState() => _AuthChallengeSheetState();
}

class _AuthChallengeSheetState extends ConsumerState<AuthChallengeSheet> {
  String _pin = '';
  bool _isError = false;
  int? _lockoutSeconds;

  @override
  void initState() {
    super.initState();
    _checkLockout();
    _attemptBiometrics();
  }

  Future<void> _checkLockout() async {
    final remaining = await RateLimiter().checkWaitTimeRemaining();
    if (remaining > 0 && mounted) {
      setState(() => _lockoutSeconds = remaining);
    }
  }

  Future<void> _attemptBiometrics() async {
    final enabled = ref.read(biometricsEnabledProvider).valueOrNull ?? false;
    if (enabled) {
      final success = await AuthBarrier(RateLimiter()).authenticateBiometricsOnly();
      if (success && mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  void _onDigitPressed(String digit) {
    if (_lockoutSeconds != null && _lockoutSeconds! > 0) return;
    if (_pin.length < VaultConfig.pinLength) {
      HapticFeedback.selectionClick();
      setState(() {
        _pin += digit;
        _isError = false;
      });
      if (_pin.length == VaultConfig.pinLength) {
        _verify();
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _verify() async {
    final barrier = AuthBarrier(RateLimiter());
    final result = await barrier.authenticate(_pin);

    if (result is AuthSuccess) {
      if (mounted) Navigator.of(context).pop(true);
    } else if (result is AuthTimeoutBlock) {
      setState(() {
        _lockoutSeconds = result.secondsRemaining;
        _pin = '';
      });
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _isError = true;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: ColdBitTheme.obsidianBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          
          Text(
            "AUTHORIZE SIGNING",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
              color: ColdBitTheme.goldBitcoin,
            ),
          ).animate().fade(),
          
          const SizedBox(height: 8),
          
          Text(
            _isError ? "Invalid PIN" : "Confirm identity to access secure keys",
            style: TextStyle(
              color: _isError ? ColdBitTheme.errorCrimson : ColdBitTheme.platinumText,
              fontSize: 14,
            ),
          ).animate(key: ValueKey(_isError)).shake(),

          const SizedBox(height: 48),

          // PIN Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(VaultConfig.pinLength, (index) {
              final isFilled = index < _pin.length;
              return AnimatedContainer(
                duration: 200.ms,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? ColdBitTheme.goldBitcoin : Colors.transparent,
                  border: Border.all(
                    color: isFilled ? ColdBitTheme.goldBitcoin : ColdBitTheme.brushedMetal.withValues(alpha: 0.5),
                    width: 2.5,
                  ),
                ),
              );
            }),
          ),

          const Spacer(),

          // Numpad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int i = 1; i <= 9; i++) _buildKey(i.toString()),
                _buildIconKey(LucideIcons.fingerprint, _attemptBiometrics),
                _buildKey('0'),
                _buildIconKey(LucideIcons.delete, _onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label) {
    return _NumpadKey(label: label, onTap: () => _onDigitPressed(label));
  }

  Widget _buildIconKey(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Center(
        child: Icon(icon, color: ColdBitTheme.platinumText, size: 28),
      ),
    );
  }
}

class _NumpadKey extends StatefulWidget {
  const _NumpadKey({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: 100.ms,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPressed ? ColdBitTheme.brushedMetal : Colors.transparent,
          border: Border.all(
            color: _isPressed 
              ? ColdBitTheme.goldBitcoin.withValues(alpha: 0.5) 
              : ColdBitTheme.brushedMetal.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: _isPressed ? ColdBitTheme.goldBitcoin : Colors.white,
          ),
        ),
      ),
    );
  }
}
