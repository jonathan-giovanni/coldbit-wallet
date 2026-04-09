import 'dart:ui';

import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';

class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius,
  });
  final Widget child;
  final double blur;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20.0);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: ColdBitTheme.frostedGlass,
            borderRadius: radius,
            border: Border.all(
              color: ColdBitTheme.pureWhiteText.withValues(alpha: 0.08),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
