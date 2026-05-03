import 'package:coldbit_wallet/core/providers/biometrics_provider.dart';
import 'package:coldbit_wallet/core/providers/locale_provider.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
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

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  bool _cameraGranted = false;
  bool _notificationsGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncSettingsState());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncSettingsState();
    }
  }

  Future<void> _syncSettingsState() async {
    if (!mounted) return;
    ref.invalidate(biometricsEnabledProvider);
    await _checkPermissions();
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
    await _syncSettingsState();
  }

  @override
  Widget build(BuildContext context) {
    final biometricsAsync = ref.watch(biometricsEnabledProvider);
    final biometricsEnabled = biometricsAsync.valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: ColdBitTheme.goldBitcoin,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildLanguageSelector(context, ref),
            const SizedBox(height: 16),
            _buildToggle(
              context,
              icon: LucideIcons.camera,
              title: AppLocalizations.of(context)!.settingsCamera,
              subtitle: AppLocalizations.of(context)!.settingsCameraDesc,
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
              title: AppLocalizations.of(context)!.settingsPush,
              subtitle: AppLocalizations.of(context)!.settingsPushDesc,
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
              title: AppLocalizations.of(context)!.settingsBiometrics,
              subtitle: AppLocalizations.of(context)!.settingsBiometricsDesc,
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

  Widget _buildLanguageSelector(BuildContext context, WidgetRef ref) {
    final curLocale = ref.watch(localeProvider)?.languageCode ?? 'en';
    final isEsp = curLocale == 'es';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColdBitTheme.obsidianBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColdBitTheme.goldBitcoin.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.settingsLanguage,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColdBitTheme.pureWhiteText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.settingsLanguageDesc,
            style: const TextStyle(
              color: ColdBitTheme.platinumText,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      ref.read(localeProvider.notifier).setLocale('en'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !isEsp
                        ? ColdBitTheme.goldBitcoin
                        : ColdBitTheme.darkGraphite,
                    foregroundColor: !isEsp
                        ? ColdBitTheme.obsidianBlack
                        : ColdBitTheme.platinumText,
                  ),
                  child: const Text('EN'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      ref.read(localeProvider.notifier).setLocale('es'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEsp
                        ? ColdBitTheme.goldBitcoin
                        : ColdBitTheme.darkGraphite,
                    foregroundColor: isEsp
                        ? ColdBitTheme.obsidianBlack
                        : ColdBitTheme.platinumText,
                  ),
                  child: const Text('ES'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColdBitTheme.obsidianBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColdBitTheme.brushedMetal.withValues(alpha: 0.3),
        ),
      ),
      child: SwitchListTile(
        activeThumbColor: ColdBitTheme.goldBitcoin,
        inactiveThumbColor: ColdBitTheme.platinumText,
        inactiveTrackColor: ColdBitTheme.obsidianBlack,
        secondary: Icon(
          icon,
          color: value ? ColdBitTheme.goldBitcoin : ColdBitTheme.platinumText,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ColdBitTheme.pureWhiteText,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: ColdBitTheme.platinumText),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
