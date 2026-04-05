import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/screens/pin_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Pin Setup strict loop: Create -> Confirm -> Mismatch resets', (
    WidgetTester tester,
  ) async {
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
          home: Scaffold(body: PinSetupScreen()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Establish your Secure PIN'), findsOneWidget);

    for (int i = 1; i <= 6; i++) {
      await tester.tap(find.text('$i'));
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('Confirm your Secure PIN'), findsOneWidget);

    for (int i = 6; i >= 1; i--) {
      await tester.tap(find.text('$i'));
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('PINs do not match'), findsOneWidget);
  });
}
