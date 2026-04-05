import 'package:coldbit_wallet/presentation/screens/pin_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Pin Setup strict loop: Create -> Confirm -> Mismatch (typo) logic test', (WidgetTester tester) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: PinSetupScreen()),
        ),
      ),
    );

    // 2. Validate Phase 1 UI.
    expect(find.text('Create Vault PIN'), findsOneWidget);

    // 3. User types 1-2-3-4-5-6
    for (int i = 1; i <= 6; i++) {
      await tester.tap(find.text('$i'));
      await tester.pump(const Duration(milliseconds: 100));
    }
    
    // Wait for the UI micro-pause (300ms) logic transition
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    // 4. Validate Phase 2 UI.
    expect(find.text('Confirm Vault PIN'), findsOneWidget);

    // 5. User types WRONG pass: 6-5-4-3-2-1
    for (int i = 6; i >= 1; i--) {
      await tester.tap(find.text('$i'));
      await tester.pump(const Duration(milliseconds: 100));
    }
    
    // Wait for validation transition
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    // 6. Validate System caught the typoo and vibrated.
    expect(find.text('PIN Mismatch. Restarting.'), findsOneWidget);
  });
}
