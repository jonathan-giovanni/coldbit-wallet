import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StatusPill extends StatelessWidget {

  const StatusPill({
    super.key,
    required this.label,
    this.dotColor = ColdBitTheme.successGreen,
  });
  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: ColdBitTheme.brushedMetal.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: ColdBitTheme.pureWhiteText.withValues(alpha: 0.05),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ],
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .fade(duration: 1.seconds, curve: Curves.easeInOut)
          .then()
          .fade(duration: 1.seconds, curve: Curves.easeInOut, begin: 1.0, end: 0.3),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: ColdBitTheme.platinumText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
