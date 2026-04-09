import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  setUpAll(() {
    Animate.restartOnHotReload = false;
  });

  testWidgets('ColdBit Wallet shows logo and onboarding introduction', (
    WidgetTester tester,
  ) async {
    // Set a consistent screen size for the luxury UI
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: OnboardingScreen(),
        ),
      ),
    );

    // We DO NOT use pumpAndSettle here because the luxury UI contains infinite shimmering animations.
    // Instead, we pump enough frames for the PageView and its children to render.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify some text content exists to prove rendering.
    // We look for parts of the title without assuming casing or full string.
    expect(
      find.textContaining(
        'Air-Gapped',
        findRichText: true,
        skipOffstage: false,
      ),
      findsWidgets,
    );

    // Alternative: Find by icon which is part of the first slide
    expect(find.byIcon(LucideIcons.shieldCheck), findsOneWidget);
  });
}
