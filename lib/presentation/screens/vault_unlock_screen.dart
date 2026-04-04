import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VaultUnlockScreen extends StatefulWidget {
  const VaultUnlockScreen({super.key});

  @override
  State<VaultUnlockScreen> createState() => _VaultUnlockScreenState();
}

class _VaultUnlockScreenState extends State<VaultUnlockScreen> {
  String _pin = '';

  void _onDigitPressed(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 6) {
        _unlock();
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _unlock() {
    // In a real flow, this invokes auth_barrier.dart
    Future.delayed(500.ms, () {
      if (mounted) context.go('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(LucideIcons.lock, size: 48, color: ColdBitTheme.platinumText)
                .animate().fade().slideY(begin: -0.5),
            const SizedBox(height: 24),
            Text(
              'Enter PIN Code',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ).animate().fade(delay: 200.ms),
            const SizedBox(height: 32),
            
            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                final isFilled = index < _pin.length;
                return AnimatedContainer(
                  duration: 200.ms,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? ColdBitTheme.goldBitcoin : Colors.transparent,
                    border: Border.all(
                      color: isFilled ? ColdBitTheme.goldBitcoin : ColdBitTheme.brushedMetal,
                      width: 2,
                    ),
                    boxShadow: isFilled ? ColdBitTheme.glowShadow : null,
                  ),
                );
              }),
            ),
            
            const Spacer(),
            
            // Numpad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 1; i <= 9; i++) _buildNumKey(i.toString()),
                  _buildIconKey(Icons.fingerprint, () => _unlock()),
                  _buildNumKey('0'),
                  _buildIconKey(LucideIcons.delete, _onDeletePressed),
                ],
              ).animate().fade(delay: 400.ms).slideY(begin: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumKey(String digit) {
    return _NumKey(
      label: digit,
      onPressed: () => _onDigitPressed(digit),
    );
  }

  Widget _buildIconKey(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Center(
        child: Icon(icon, size: 28, color: ColdBitTheme.platinumText),
      ),
    );
  }
}

class _NumKey extends StatefulWidget {

  const _NumKey({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: 100.ms,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPressed ? ColdBitTheme.brushedMetal : Colors.transparent,
          border: Border.all(
            color: _isPressed ? ColdBitTheme.goldBitcoin.withValues(alpha: 0.5) : ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: _isPressed ? ColdBitTheme.goldBitcoin : ColdBitTheme.pureWhiteText,
              ),
        ),
      ).animate(target: _isPressed ? 1 : 0).scale(end: const Offset(0.9, 0.9), duration: 100.ms),
    );
  }
}
