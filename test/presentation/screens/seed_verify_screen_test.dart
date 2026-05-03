import 'package:coldbit_wallet/core/providers/seed_provider.dart';
import 'package:coldbit_wallet/core/security/mem_guard.dart';
import 'package:coldbit_wallet/core/theme/coldbit_theme.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/screens/seed_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mnemonic =
      'abandon ability able about above absent absorb abstract absurd abuse access accident';

  setUpAll(() async {
    await MemGuard.init();
  });

  Widget harness(SeedProvider seededProvider) {
    return ProviderScope(
      overrides: [seedProviderProviderOverride(seededProvider)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: SeedVerifyScreen(
          challengeIndicesForTesting: [0],
          optionsForTesting: {
            0: ['abandon', 'ability', 'able', 'about'],
          },
        ),
      ),
    );
  }

  testWidgets('keeps verification options stable after selecting a word', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final seed = SeedProvider()..setSeed(mnemonic);

    await tester.pumpWidget(harness(seed));
    await tester.pump();

    for (final word in ['abandon', 'ability', 'able', 'about']) {
      expect(find.text(word), findsOneWidget);
    }

    await tester.tap(find.text('ability'));
    await tester.pump();

    for (final word in ['abandon', 'ability', 'able', 'about']) {
      expect(find.text(word), findsOneWidget);
    }
    expect(_optionColor(tester, 'ability'), ColdBitTheme.goldBitcoin);
    expect(_optionColor(tester, 'abandon'), ColdBitTheme.obsidianBlack);

    await tester.tap(find.text('abandon'));
    await tester.pump();

    for (final word in ['abandon', 'ability', 'able', 'about']) {
      expect(find.text(word), findsOneWidget);
    }
    expect(_optionColor(tester, 'abandon'), ColdBitTheme.goldBitcoin);
    expect(_optionColor(tester, 'ability'), ColdBitTheme.obsidianBlack);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}

Override seedProviderProviderOverride(SeedProvider seededProvider) {
  return seedProvider.overrideWith((ref) => seededProvider);
}

Color? _optionColor(WidgetTester tester, String word) {
  final containerFinder = find.ancestor(
    of: find.text(word),
    matching: find.byType(AnimatedContainer),
  );
  final container = tester.widget<AnimatedContainer>(containerFinder.first);
  final decoration = container.decoration as BoxDecoration?;
  return decoration?.color;
}
