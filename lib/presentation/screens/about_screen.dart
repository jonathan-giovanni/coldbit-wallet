import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutTitle),
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: ColdBitTheme.goldBitcoin,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Markdown(
          data: AppLocalizations.of(context)!.aboutMissionMd,
          styleSheet: MarkdownStyleSheet(
            h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: ColdBitTheme.pureWhiteText,
              fontWeight: FontWeight.bold,
            ),
            h2: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ColdBitTheme.goldBitcoin,
              fontWeight: FontWeight.bold,
            ),
            p: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ColdBitTheme.platinumText,
              height: 1.6,
            ),
            listBullet: const TextStyle(color: ColdBitTheme.goldBitcoin),
          ),
        ),
      ),
    );
  }
}
