import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ColdBitActionButton extends StatefulWidget {
  const ColdBitActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isPrimary = true,
  });
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isPrimary;

  @override
  State<ColdBitActionButton> createState() => _ColdBitActionButtonState();
}

class _ColdBitActionButtonState extends State<ColdBitActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isPrimary
        ? ColdBitTheme.goldBitcoin
        : Colors.transparent;
    final textColor = widget.isPrimary
        ? ColdBitTheme.obsidianBlack
        : ColdBitTheme.goldBitcoin;
    final borderColor = widget.isPrimary
        ? Colors.transparent
        : ColdBitTheme.goldBitcoin;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child:
          Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18.0,
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: widget.isPrimary && !_isPressed
                      ? ColdBitTheme.glowShadow
                      : null,
                  gradient: widget.isPrimary ? ColdBitTheme.goldGradient : null,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: textColor,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: textColor, size: 20),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label.toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ],
                        ),
                ),
              )
              .animate(target: _isPressed ? 1 : 0)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(0.96, 0.96),
                duration: 100.ms,
                curve: Curves.easeOutCubic,
              ),
    );
  }
}
