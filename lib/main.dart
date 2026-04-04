import 'package:coldbit_wallet/core/router/app_router.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Security Sandboxes
  await MemGuard.init();

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

  runApp(
    const ProviderScope(
      child: ColdBitApp(),
    ),
  );
}

class ColdBitApp extends StatelessWidget {
  const ColdBitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ColdBit Vault',
      debugShowCheckedModeBanner: false,
      theme: ColdBitTheme.luxuryTheme,
      routerConfig: appRouter,
    );
  }
}
