import 'package:coldbit_wallet/core/crypto/mnemonic_strength.dart';
import 'package:coldbit_wallet/core/providers/mnemonic_policy_provider.dart';
import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/presentation/screens/backup_discipline_screen.dart';
import 'package:coldbit_wallet/presentation/screens/intro_screen.dart';
import 'package:coldbit_wallet/presentation/screens/mnemonic_length_screen.dart';
import 'package:coldbit_wallet/presentation/screens/security_briefing_screen.dart';
import 'package:coldbit_wallet/presentation/screens/vault_mode_screen.dart';
import 'package:coldbit_wallet/presentation/screens/vault_unlock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    Animate.restartOnHotReload = false;
  });

  Widget localizedHarness(Widget child, {ProviderContainer? container}) {
    final app = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: child,
    );

    if (container != null) {
      return UncontrolledProviderScope(container: container, child: app);
    }

    return ProviderScope(child: app);
  }

  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> clearWidgetTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  testWidgets('intro screen explains onboarding entry point', (tester) async {
    useTallViewport(tester);

    await tester.pumpWidget(localizedHarness(const IntroScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('ColdBit Wallet'), findsOneWidget);
    expect(find.text('START ONBOARDING'), findsOneWidget);
    expect(find.text('Recover existing vault'), findsOneWidget);

    await clearWidgetTree(tester);
  });

  testWidgets('security briefing renders the non-negotiable rules', (
    tester,
  ) async {
    useTallViewport(tester);

    await tester.pumpWidget(localizedHarness(const SecurityBriefingScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Operational Briefing'), findsOneWidget);
    expect(find.text('Keep the signer offline'), findsOneWidget);
    expect(find.text('The seed is the vault'), findsOneWidget);
    expect(find.text('Review every PSBT'), findsOneWidget);

    await clearWidgetTree(tester);
  });

  testWidgets('vault mode exposes create and recover paths', (tester) async {
    useTallViewport(tester);

    await tester.pumpWidget(localizedHarness(const VaultModeScreen()));
    await tester.pump();

    expect(find.text('Choose Vault Mode'), findsOneWidget);
    expect(find.text('CREATE NEW VAULT'), findsOneWidget);
    expect(find.text('RECOVER VAULT'), findsOneWidget);

    await clearWidgetTree(tester);
  });

  testWidgets('mnemonic length selection writes the user choice', (
    tester,
  ) async {
    useTallViewport(tester);
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      localizedHarness(const MnemonicLengthScreen(), container: container),
    );
    await tester.pump();

    expect(container.read(mnemonicStrengthProvider), MnemonicStrength.words24);

    await tester.tap(find.text('12 words'));
    await tester.pump();

    expect(container.read(mnemonicStrengthProvider), MnemonicStrength.words12);
    expect(find.text('PREPARE BACKUP'), findsOneWidget);

    await clearWidgetTree(tester);
  });

  testWidgets('backup discipline screen prepares physical seed handling', (
    tester,
  ) async {
    useTallViewport(tester);

    await tester.pumpWidget(localizedHarness(const BackupDisciplineScreen()));
    await tester.pump();

    expect(find.text('Backup Discipline'), findsOneWidget);
    expect(find.text('Use physical media'), findsOneWidget);
    expect(find.text('Never photograph it'), findsOneWidget);
    expect(find.text('CREATE SECURE PIN'), findsOneWidget);

    await clearWidgetTree(tester);
  });

  testWidgets('unlock screen exposes a visible entry back to onboarding', (
    tester,
  ) async {
    useTallViewport(tester);

    await tester.pumpWidget(localizedHarness(const VaultUnlockScreen()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Create or recover wallet'), findsOneWidget);
    expect(
      find.text(
        'Use this if you want to start the onboarding flow again on this device.',
      ),
      findsOneWidget,
    );

    await clearWidgetTree(tester);
  });
}
