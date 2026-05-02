import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                LucideIcons.snowflake,
                size: 72,
                color: ColdBitTheme.goldBitcoin,
              ).animate().fade().scale(
                begin: const Offset(0.85, 0.85),
                duration: 450.ms,
              ),
              const SizedBox(height: 32),
              Text(
                loc.introTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ).animate().fade(delay: 100.ms).slideY(begin: 0.08),
              const SizedBox(height: 14),
              Text(
                loc.introSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ).animate().fade(delay: 180.ms).slideY(begin: 0.08),
              const Spacer(),
              ColdBitActionButton(
                label: loc.introBeginBtn,
                icon: LucideIcons.arrowRight,
                onPressed: () => context.push('/security-briefing'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.push('/recover'),
                child: Text(loc.introRecoverBtn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
