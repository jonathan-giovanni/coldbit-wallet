import 'package:coldbit_wallet/core/providers/locale_provider.dart';
import 'package:coldbit_wallet/core/router/app_router.dart';
import 'package:coldbit_wallet/core/security/app_lifecycle_guard.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/security/threat_detector.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Security Sandboxes
  await MemGuard.init();
  await ThreatDetector.init();

  // Force dark mode UI Overlays globally
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ColdBitTheme.obsidianBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Restrict to portrait given the numpad and scanner UX priority
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: AppLifecycleGuard(child: ColdBitApp())));
}

class ColdBitApp extends ConsumerWidget {
  const ColdBitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title:
          'ColdBit Vault', // Mantenemos este title fuera de loc para el OS si queremos, o usamos onGenerateTitle
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ColdBitTheme.luxuryTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: goRouter,
    );
  }
}
