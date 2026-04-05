import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ColdBitDrawer extends StatefulWidget {
  const ColdBitDrawer({super.key});

  @override
  State<ColdBitDrawer> createState() => _ColdBitDrawerState();
}

class _ColdBitDrawerState extends State<ColdBitDrawer> {
  String _version = 'v1.0.0-alpha';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = 'v${info.version} • Fallback: Hoy';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColdBitTheme.obsidianBlack.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Row(
                children: [
                  const Icon(LucideIcons.shieldCheck, color: ColdBitTheme.goldBitcoin, size: 28),
                  const SizedBox(width: 16),
                  Text(
                    'COLDBIT',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                          color: ColdBitTheme.pureWhiteText,
                        ),
                  ),
                ],
              ),
            ),
            Divider(color: ColdBitTheme.brushedMetal.withValues(alpha: 0.5), height: 1),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(LucideIcons.settings, color: ColdBitTheme.platinumText),
              title: const Text('Ajustes de Bóveda', style: TextStyle(color: ColdBitTheme.pureWhiteText, fontWeight: FontWeight.w600)),
              onTap: () {
                context.pop();
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.bookOpen, color: ColdBitTheme.platinumText),
              title: const Text('Acerca del Proyecto', style: TextStyle(color: ColdBitTheme.pureWhiteText, fontWeight: FontWeight.w600)),
              onTap: () {
                context.pop();
                context.push('/about');
              },
            ),
            const Spacer(),
            Divider(color: ColdBitTheme.brushedMetal.withValues(alpha: 0.5), height: 1),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _version,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ColdBitTheme.platinumText,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
