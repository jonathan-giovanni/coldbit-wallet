import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _cameraGranted = false;
  bool _notificationsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camera = await Permission.camera.status;
    final notif = await Permission.notification.status;
    if (mounted) {
      setState(() {
        _cameraGranted = camera.isGranted;
        _notificationsGranted = notif.isGranted;
      });
    }
  }

  Future<void> _handlePermission(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    await _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final biometricsAsync = ref.watch(biometricsEnabledProvider);
    final biometricsEnabled = biometricsAsync.valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Bóveda'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: ColdBitTheme.goldBitcoin),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildToggle(
              context,
              icon: LucideIcons.camera,
              title: 'Cámara (Escáner QR)',
              subtitle: 'Requerida para importar PSBTs de red abierta',
              value: _cameraGranted,
              onChanged: (val) {
                if (val) {
                   _handlePermission(Permission.camera);
                } else {
                   openAppSettings();
                }
              },
            ),
            const SizedBox(height: 16),
            _buildToggle(
              context,
              icon: LucideIcons.bellRing,
              title: 'Notificaciones Push',
              subtitle: 'Alertas locales de escaneos o detecciones de jailbreak',
              value: _notificationsGranted,
              onChanged: (val) {
                if (val) {
                   _handlePermission(Permission.notification);
                } else {
                   openAppSettings();
                }
              },
            ),
            const SizedBox(height: 16),
            _buildToggle(
              context,
              icon: LucideIcons.scanFace,
              title: 'Autenticación Biométrica',
              subtitle: 'Reemplaza el tecleo de PIN manual en desbloqueos cortos',
              value: biometricsEnabled,
              onChanged: (val) async {
                 await ColdBitSettings.updateBiometricsStatus(val);
                 ref.invalidate(biometricsEnabledProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(BuildContext context, {required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: ColdBitTheme.obsidianBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3)),
      ),
      child: SwitchListTile(
        activeThumbColor: ColdBitTheme.goldBitcoin,
        inactiveThumbColor: ColdBitTheme.platinumText,
        inactiveTrackColor: ColdBitTheme.obsidianBlack,
        secondary: Icon(icon, color: value ? ColdBitTheme.goldBitcoin : ColdBitTheme.platinumText),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: ColdBitTheme.pureWhiteText)),
        subtitle: Text(subtitle, style: const TextStyle(color: ColdBitTheme.platinumText)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
