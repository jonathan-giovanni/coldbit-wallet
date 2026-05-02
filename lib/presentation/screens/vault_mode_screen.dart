import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VaultModeScreen extends StatelessWidget {
  const VaultModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
                loc.vaultModeTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                loc.vaultModeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              _ModePanel(
                icon: LucideIcons.plusCircle,
                title: loc.vaultModeCreateTitle,
                description: loc.vaultModeCreateDesc,
              ),
              const SizedBox(height: 14),
              _ModePanel(
                icon: LucideIcons.rotateCcw,
                title: loc.vaultModeRecoverTitle,
                description: loc.vaultModeRecoverDesc,
              ),
              const Spacer(),
              ColdBitActionButton(
                label: loc.vaultModeCreateBtn,
                icon: LucideIcons.plusCircle,
                onPressed: () => context.push('/mnemonic-length'),
              ),
              const SizedBox(height: 12),
              ColdBitActionButton(
                label: loc.vaultModeRecoverBtn,
                icon: LucideIcons.rotateCcw,
                isPrimary: false,
                onPressed: () => context.push('/recover'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModePanel extends StatelessWidget {
  const _ModePanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColdBitTheme.darkGraphite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColdBitTheme.brushedMetal),
      ),
      child: Row(
        children: [
          Icon(icon, color: ColdBitTheme.goldBitcoin, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
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
    );
  }
}
