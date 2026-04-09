import 'package:coldbit_wallet/core/config/vault_config.dart';
import 'package:coldbit_wallet/core/providers/auth_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum PinSetupState { create, confirm }

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  PinSetupState _state = PinSetupState.create;
  String _initialPin = '';
  String _currentPin = '';
  bool _isError = false;

  void _onDigitPressed(String digit) {
    if (_currentPin.length < VaultConfig.pinLength) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentPin += digit;
        _isError = false;
      });
      if (_currentPin.length == VaultConfig.pinLength) {
        _processStep();
      }
    }
  }

  void _onDeletePressed() {
    if (_currentPin.isNotEmpty) {
      setState(() {
        _currentPin = _currentPin.substring(0, _currentPin.length - 1);
        _isError = false;
      });
    }
  }

  Future<void> _processStep() async {
    await Future.delayed(300.ms); // Micro pausa UX

    if (!mounted) return;

    if (_state == PinSetupState.create) {
      setState(() {
        _initialPin = _currentPin;
        _currentPin = '';
        _state = PinSetupState.confirm;
      });
    } else {
      if (_currentPin == _initialPin) {
        // Ejecución Dual Auth Registration
        ref.read(authProvider.notifier).setupNewVault(_currentPin);
      } else {
        HapticFeedback.heavyImpact();
        // Disparar error TyP
        setState(() {
          _isError = true;
          _currentPin = '';
          _initialPin = '';
          _state = PinSetupState.create;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _state == PinSetupState.create
        ? AppLocalizations.of(context)!.pinSetupCreateMsg
        : AppLocalizations.of(context)!.pinSetupConfirmMsg;

    final icon = _state == PinSetupState.create
        ? LucideIcons.key
        : LucideIcons.checkSquare;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _state == PinSetupState.confirm
            ? IconButton(
                icon: const Icon(
                  LucideIcons.arrowLeft,
                  color: ColdBitTheme.goldBitcoin,
                ),
                onPressed: () {
                  setState(() {
                    _state = PinSetupState.create;
                    _currentPin = '';
                    _initialPin = '';
                  });
                },
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(
                  _isError ? LucideIcons.shieldAlert : icon,
                  size: 64,
                  color: _isError
                      ? ColdBitTheme.errorCrimson
                      : ColdBitTheme.goldBitcoin,
                )
                .animate(key: ValueKey(_state.name + _isError.toString()))
                .scale(begin: const Offset(0.8, 0.8), duration: 400.ms)
                .shimmer(delay: 400.ms),

            const SizedBox(height: 32),

            Text(
                  _isError
                      ? AppLocalizations.of(context)!.pinSetupMismatch.toUpperCase()
                      : title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontSize: 20,
                    color: _isError ? ColdBitTheme.errorCrimson : Colors.white,
                  ),
                )
                .animate(key: ValueKey(title + _isError.toString()))
                .fade()
                .slideY(begin: 0.2),

            const SizedBox(height: 12),
            
            if (!_isError)
              Text(
                _state == PinSetupState.create
                    ? "Choose a 6-digit access code"
                    : "Repeat the code to verify accuracy",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColdBitTheme.platinumText,
                ),
              ).animate().fade(),

            const SizedBox(height: 48),

            // PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(VaultConfig.pinLength, (index) {
                final isFilled = index < _currentPin.length;
                return AnimatedContainer(
                  duration: 200.ms,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isError
                        ? ColdBitTheme.errorCrimson
                        : isFilled
                        ? ColdBitTheme.goldBitcoin
                        : Colors.transparent,
                    border: Border.all(
                      color: _isError
                          ? ColdBitTheme.errorCrimson
                          : isFilled
                          ? ColdBitTheme.goldBitcoin
                          : ColdBitTheme.brushedMetal.withValues(alpha: 0.5),
                      width: 2.5,
                    ),
                    boxShadow: isFilled && !_isError
                        ? ColdBitTheme.glowShadow
                        : null,
                  ),
                );
              }),
            ).animate(target: _isError ? 1 : 0).shake(hz: 8, duration: 500.ms),

            const Spacer(),

            // Numpad
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 48.0,
                vertical: 32.0,
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (int i = 1; i <= 9; i++) _buildNumKey(i.toString()),
                  const SizedBox.shrink(),
                  _buildNumKey('0'),
                  _buildIconKey(LucideIcons.delete, _onDeletePressed),
                ],
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumKey(String digit) {
    return _NumKey(label: digit, onPressed: () => _onDigitPressed(digit));
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
      child:
          AnimatedContainer(
                duration: 100.ms,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isPressed
                      ? ColdBitTheme.brushedMetal
                      : Colors.transparent,
                  border: Border.all(
                    color: _isPressed
                        ? ColdBitTheme.goldBitcoin.withValues(alpha: 0.5)
                        : ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _isPressed
                        ? ColdBitTheme.goldBitcoin
                        : ColdBitTheme.pureWhiteText,
                  ),
                ),
              )
              .animate(target: _isPressed ? 1 : 0)
              .scale(end: const Offset(0.9, 0.9), duration: 100.ms),
    );
  }
}
