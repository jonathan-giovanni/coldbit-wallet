import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SlideToSign extends StatefulWidget {
  const SlideToSign({super.key, required this.onSign});
  final Future<void> Function() onSign;

  @override
  State<SlideToSign> createState() => _SlideToSignState();
}

class _SlideToSignState extends State<SlideToSign> {
  double _dragPosition = 0.0;
  bool _isSigning = false;
  final double _knobSize = 64.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - _knobSize;

        return Container(
          height: _knobSize,
          decoration: BoxDecoration(
            color: ColdBitTheme.darkGraphite.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(
              color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
            ),
            boxShadow: ColdBitTheme.ambientShadow,
          ),
          child: Stack(
            children: [
              Center(
                child: _isSigning
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: ColdBitTheme.goldBitcoin,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'SLIDE TO SIGN',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: ColdBitTheme.platinumText,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              // Progress Fill
              Container(
                width: _dragPosition + _knobSize,
                decoration: BoxDecoration(
                  color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),

              // Draggable Knob
              Positioned(
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (_isSigning) return;
                    setState(() {
                      _dragPosition += details.delta.dx;
                      if (_dragPosition < 0) _dragPosition = 0;
                      if (_dragPosition > maxDrag) _dragPosition = maxDrag;
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    if (_isSigning) return;
                    if (_dragPosition > maxDrag * 0.8) {
                      // Trigger Sign
                      setState(() {
                        _dragPosition = maxDrag;
                        _isSigning = true;
                      });

                      try {
                        await widget.onSign();
                      } finally {
                        setState(() {
                          _dragPosition = 0;
                          _isSigning = false;
                        });
                      }
                    } else {
                      // Reset
                      setState(() => _dragPosition = 0);
                    }
                  },
                  child: Container(
                    width: _knobSize,
                    height: _knobSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColdBitTheme.pureWhiteText,
                      boxShadow: [
                        BoxShadow(
                          color: ColdBitTheme.goldBitcoin.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.fingerprint,
                      color: ColdBitTheme.obsidianBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
