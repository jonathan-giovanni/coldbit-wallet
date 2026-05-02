import 'package:coldbit_wallet/core/crypto/mnemonic_strength.dart';
import 'package:coldbit_wallet/core/providers/mnemonic_policy_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MnemonicLengthScreen extends ConsumerWidget {
  const MnemonicLengthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final selected = ref.watch(mnemonicStrengthProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.mnemonicLengthTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                loc.mnemonicLengthSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              _StrengthTile(
                selected: selected == MnemonicStrength.words24,
                title: loc.mnemonicLength24Title,
                description: loc.mnemonicLength24Desc,
                onTap: () => ref.read(mnemonicStrengthProvider.notifier).state =
                    MnemonicStrength.words24,
              ),
              const SizedBox(height: 12),
              _StrengthTile(
                selected: selected == MnemonicStrength.words12,
                title: loc.mnemonicLength12Title,
                description: loc.mnemonicLength12Desc,
                onTap: () => ref.read(mnemonicStrengthProvider.notifier).state =
                    MnemonicStrength.words12,
              ),
              const Spacer(),
              ColdBitActionButton(
                label: loc.mnemonicLengthContinueBtn,
                icon: LucideIcons.arrowRight,
                onPressed: () => context.push('/backup-discipline'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StrengthTile extends StatelessWidget {
  const _StrengthTile({
    required this.selected,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColdBitTheme.darkGraphite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? ColdBitTheme.goldBitcoin
                : ColdBitTheme.brushedMetal,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? LucideIcons.checkCircle : LucideIcons.circle,
              color: selected
                  ? ColdBitTheme.goldBitcoin
                  : ColdBitTheme.platinumText,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColdBitTheme.platinumText,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
