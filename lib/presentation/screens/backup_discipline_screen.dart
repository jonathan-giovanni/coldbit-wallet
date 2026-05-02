import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/widgets/coldbit_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BackupDisciplineScreen extends StatelessWidget {
  const BackupDisciplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final checks = [
      _BackupCheck(
        icon: LucideIcons.penTool,
        title: loc.backupDisciplinePaperTitle,
        description: loc.backupDisciplinePaperDesc,
      ),
      _BackupCheck(
        icon: LucideIcons.eyeOff,
        title: loc.backupDisciplinePrivacyTitle,
        description: loc.backupDisciplinePrivacyDesc,
      ),
      _BackupCheck(
        icon: LucideIcons.cameraOff,
        title: loc.backupDisciplineNoPhotoTitle,
        description: loc.backupDisciplineNoPhotoDesc,
      ),
      _BackupCheck(
        icon: LucideIcons.lock,
        title: loc.backupDisciplineStorageTitle,
        description: loc.backupDisciplineStorageDesc,
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
                loc.backupDisciplineTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                loc.backupDisciplineSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColdBitTheme.platinumText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: checks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _BackupCheckRow(check: checks[index]);
                  },
                ),
              ),
              ColdBitActionButton(
                label: loc.backupDisciplineContinueBtn,
                icon: LucideIcons.arrowRight,
                onPressed: () => context.push('/setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackupCheck {
  const _BackupCheck({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _BackupCheckRow extends StatelessWidget {
  const _BackupCheckRow({required this.check});

  final _BackupCheck check;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(check.icon, color: ColdBitTheme.goldBitcoin, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  check.description,
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
