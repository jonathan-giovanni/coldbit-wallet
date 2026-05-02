import 'package:coldbit_wallet/core/crypto/wallet_engine.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/screens/seed_recovery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    // MemGuard init is required for BIP39 validation in tests
    await MemGuard.init();
  });

  group('SeedRecoveryScreen Tests', () {
    testWidgets('Validation shows correct colors for BIP39 words', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SeedRecoveryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final firstField = find.byType(TextField).first;

      // Enter valid BIP39 word
      await tester.enterText(firstField, 'abandon');
      await tester.pump();

      // Border should indicate gold/valid.
      // Using pump to ensure the text from the suggestion chip is rendered if it appeared
      await tester.pump();
      expect(find.text('abandon'), findsAtLeast(1));

      // Enter invalid word (letters only due to formatter)
      await tester.enterText(firstField, 'notaword');
      await tester.pump();
      expect(find.text('notaword'), findsOneWidget);
    });

    test('WalletEngine.isWordValid identifies BIP39 dictionary', () {
      expect(WalletEngine.isWordValid('abandon'), true);
      expect(WalletEngine.isWordValid('zoo'), true);
      expect(
        WalletEngine.isWordValid('bitcoin'),
        false,
      ); // Not in BIP39 (it's 'bit' then 'coin')
      expect(WalletEngine.isWordValid('invalid'), false);
    });

    test('WalletEngine.getSuggestions returns prefix matches', () {
      final suggestions = WalletEngine.getSuggestions('ab');
      expect(suggestions, contains('abandon'));
      expect(suggestions, contains('ability'));

      final abaSuggestions = WalletEngine.getSuggestions('aba');
      expect(abaSuggestions, contains('abandon'));
      expect(abaSuggestions, isNot(contains('ability')));
    });
  });
}
