import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SecurityBriefingScreen extends StatelessWidget {
  const SecurityBriefingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final items = [
      _BriefingItem(
        LucideIcons.wifiOff,
        loc.briefingOfflineTitle,
        loc.briefingOfflineDesc,
      ),
      _BriefingItem(
        LucideIcons.keyRound,
        loc.briefingSeedTitle,
        loc.briefingSeedDesc,
      ),
      _BriefingItem(
        LucideIcons.scanLine,
        loc.briefingPsbtTitle,
        loc.briefingPsbtDesc,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.briefingTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                loc.briefingSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _BriefingRow(item: item)
                        .animate()
                        .fade(delay: (90 * index).ms)
                        .slideX(begin: 0.06);
                  },
                ),
              ),
              ColdBitActionButton(
                label: loc.briefingContinueBtn,
                icon: LucideIcons.shieldCheck,
                onPressed: () => context.push('/vault-mode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BriefingItem {
  const _BriefingItem(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}

class _BriefingRow extends StatelessWidget {
  const _BriefingRow({required this.item});

  final _BriefingItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColdBitTheme.darkGraphite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColdBitTheme.brushedMetal),
          ),
          child: Icon(item.icon, color: ColdBitTheme.goldBitcoin, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
