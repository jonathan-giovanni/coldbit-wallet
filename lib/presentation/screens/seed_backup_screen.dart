import 'package:coldbit_wallet/core/providers/mnemonic_policy_provider.dart';
import 'package:coldbit_wallet/core/providers/seed_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SeedBackupScreen extends ConsumerStatefulWidget {
  const SeedBackupScreen({super.key});

  @override
  ConsumerState<SeedBackupScreen> createState() => _SeedBackupScreenState();
}

class _SeedBackupScreenState extends ConsumerState<SeedBackupScreen> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    final strength = ref.read(mnemonicStrengthProvider);
    ref.read(seedProvider.notifier).generate(strength: strength);
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.read(seedProvider.notifier).words;
    final loc = AppLocalizations.of(context)!;
    final strength = ref.watch(mnemonicStrengthProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    LucideIcons.shieldAlert,
                    color: ColdBitTheme.errorCrimson,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      loc.seedBackupTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ).animate().fade().slideY(begin: -0.2),
              const SizedBox(height: 8),
              Text(
                loc.seedBackupWarning(strength.wordCount),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.errorCrimson.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ).animate().fade(delay: 200.ms),
              const SizedBox(height: 24),
              Expanded(
                child: AnimatedSwitcher(
                  duration: 400.ms,
                  child: _revealed
                      ? _buildWordGrid(context, words)
                      : _buildRevealGate(context, loc),
                ),
              ),
              const SizedBox(height: 16),
              if (_revealed)
                ColdBitActionButton(
                  label: loc.seedBackupContinueBtn,
                  icon: LucideIcons.checkCircle,
                  onPressed: () => context.push('/seed-verify'),
                ).animate().fade(delay: 300.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevealGate(BuildContext context, AppLocalizations loc) {
    return Center(
      key: const ValueKey('gate'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: ColdBitTheme.darkGraphite,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.3),
                  ),
                  boxShadow: ColdBitTheme.ambientShadow,
                ),
                child: const Icon(
                  LucideIcons.eyeOff,
                  size: 48,
                  color: ColdBitTheme.platinumText,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: 2.seconds,
              ),
          const SizedBox(height: 32),
          Text(
            loc.seedBackupHiddenTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            loc.seedBackupHiddenDesc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColdBitTheme.platinumText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColdBitTheme.goldBitcoin,
                  side: const BorderSide(color: ColdBitTheme.goldBitcoin),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => setState(() => _revealed = true),
                icon: const Icon(LucideIcons.eye),
                label: Text(loc.seedBackupRevealBtn),
              )
              .animate()
              .fade(delay: 400.ms)
              .shimmer(
                duration: 2.seconds,
                color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.2),
              ),
        ],
      ),
    );
  }

  Widget _buildWordGrid(BuildContext context, List<String> words) {
    return GridView.builder(
      key: const ValueKey('grid'),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.8,
      ),
      itemCount: words.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
              decoration: BoxDecoration(
                color: ColdBitTheme.darkGraphite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColdBitTheme.brushedMetal.withValues(alpha: 0.4),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ColdBitTheme.goldBitcoin,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    words[index],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fade(delay: (50 * index).ms)
            .slideY(begin: 0.3, duration: 300.ms);
      },
    );
  }
}
