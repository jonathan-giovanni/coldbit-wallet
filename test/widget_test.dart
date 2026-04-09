import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

    await tester.pumpAndSettle();

    // Verify the presence of the luxury branding background
    expect(find.byType(Image), findsWidgets);
    
    // Verify the first slide title (uppercase as per luxury design)
    expect(find.text('AIR-GAPPED ABSOLUTE'), findsOneWidget);
  });
}
