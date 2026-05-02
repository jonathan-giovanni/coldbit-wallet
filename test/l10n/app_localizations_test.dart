import 'package:coldbit_wallet/l10n/app_localizations.dart';
import 'package:coldbit_wallet/l10n/app_localizations_en.dart';
import 'package:coldbit_wallet/l10n/app_localizations_es.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations', () {
    test('supports English and Spanish locales', () {
      expect(AppLocalizations.supportedLocales, const [
        Locale('en'),
        Locale('es'),
      ]);
    });

    test('lookup returns concrete localizations by locale', () {
      expect(
        lookupAppLocalizations(const Locale('en')),
        isA<AppLocalizationsEn>(),
      );
      expect(
        lookupAppLocalizations(const Locale('es')),
        isA<AppLocalizationsEs>(),
      );
    });

    test('lookup rejects unsupported locales', () {
      expect(
        () => lookupAppLocalizations(const Locale('fr')),
        throwsA(isA<FlutterError>()),
      );
    });

    test('English catalog exposes every production string', () {
      final strings = _allStrings(AppLocalizationsEn());

      expect(strings, contains('ColdBit Wallet'));
      expect(strings, contains('Create 24-word Vault'));
      expect(strings, contains('Prepare backup'));
      expect(strings, contains('LOCKED. Wait 30s'));
      expect(strings, contains('Sent 0.01000000 BTC'));
      expect(
        strings,
        contains(
          'Write down these 24 words in order. This is your ONLY way to recover your wallet. Never share them. Never store them digitally.',
        ),
      );
      expect(strings, contains('Word #7'));
      expect(strings, contains('Restore Vault'));
      expect(strings.every((value) => value.trim().isNotEmpty), true);
    });

    test('Spanish catalog exposes every production string', () {
      final strings = _allStrings(AppLocalizationsEs());

      expect(strings, contains('Bóveda ColdBit'));
      expect(strings, contains('Crear bóveda de 24 palabras'));
      expect(strings, contains('Preparar respaldo'));
      expect(strings, contains('BLOQUEADO. Esperar 30s'));
      expect(strings, contains('Enviados 0.01000000 BTC'));
      expect(
        strings,
        contains(
          'Escribe estas 24 palabras en orden. Es tu ÚNICA forma de recuperar tu billetera. Nunca las compartas. Nunca las guardes digitalmente.',
        ),
      );
      expect(strings, contains('Palabra #7'));
      expect(strings, contains('Restaurar Bóveda'));
      expect(strings.every((value) => value.trim().isNotEmpty), true);
    });
  });
}

List<String> _allStrings(AppLocalizations loc) {
  return [
    loc.appTitle,
    loc.onboardingTitle,
    loc.onboardingSlide1Title,
    loc.onboardingSlide1Desc,
    loc.onboardingSlide2Title,
    loc.onboardingSlide2Desc,
    loc.onboardingSlide3Title,
    loc.onboardingSlide3Desc,
    loc.onboardingSubtitle,
    loc.onboardingCreateBtn,
    loc.onboardingCreate24Btn,
    loc.onboardingCreate12Btn,
    loc.onboardingRecoverBtn,
    loc.introTitle,
    loc.introSubtitle,
    loc.introBeginBtn,
    loc.introRecoverBtn,
    loc.briefingTitle,
    loc.briefingSubtitle,
    loc.briefingOfflineTitle,
    loc.briefingOfflineDesc,
    loc.briefingSeedTitle,
    loc.briefingSeedDesc,
    loc.briefingPsbtTitle,
    loc.briefingPsbtDesc,
    loc.briefingContinueBtn,
    loc.vaultModeTitle,
    loc.vaultModeSubtitle,
    loc.vaultModeCreateTitle,
    loc.vaultModeCreateDesc,
    loc.vaultModeRecoverTitle,
    loc.vaultModeRecoverDesc,
    loc.vaultModeCreateBtn,
    loc.vaultModeRecoverBtn,
    loc.mnemonicLengthTitle,
    loc.mnemonicLengthSubtitle,
    loc.mnemonicLength24Title,
    loc.mnemonicLength24Desc,
    loc.mnemonicLength12Title,
    loc.mnemonicLength12Desc,
    loc.mnemonicLengthContinueBtn,
    loc.backupDisciplineTitle,
    loc.backupDisciplineSubtitle,
    loc.backupDisciplinePaperTitle,
    loc.backupDisciplinePaperDesc,
    loc.backupDisciplinePrivacyTitle,
    loc.backupDisciplinePrivacyDesc,
    loc.backupDisciplineNoPhotoTitle,
    loc.backupDisciplineNoPhotoDesc,
    loc.backupDisciplineStorageTitle,
    loc.backupDisciplineStorageDesc,
    loc.backupDisciplineContinueBtn,
    loc.pinSetupTitle,
    loc.pinSetupCreateMsg,
    loc.pinSetupConfirmMsg,
    loc.pinSetupHintCreate,
    loc.pinSetupHintConfirm,
    loc.pinSetupMismatch,
    loc.biometricOptinTitle,
    loc.biometricOptinDesc,
    loc.biometricOptinReason,
    loc.biometricOptinSkipBtn,
    loc.biometricOptinConfirmBtn,
    loc.vaultUnlockAccessDenied,
    loc.vaultUnlockEnterPin,
    loc.vaultUnlockLockedWait(30),
    loc.dashboardVaultLbl,
    loc.dashboardStatusLbl,
    loc.dashboardMfLbl,
    loc.dashboardNetworkLbl,
    loc.dashboardAuthLog,
    loc.dashboardSentBtc('0.01000000'),
    loc.dashboardReadyTitle,
    loc.dashboardReadyDesc,
    loc.dashboardScanBtn,
    loc.drawerSettings,
    loc.drawerAbout,
    loc.drawerFallback,
    loc.drawerLastUpdate,
    loc.settingsTitle,
    loc.settingsLanguage,
    loc.settingsLanguageDesc,
    loc.settingsCamera,
    loc.settingsCameraDesc,
    loc.settingsPush,
    loc.settingsPushDesc,
    loc.settingsBiometrics,
    loc.settingsBiometricsDesc,
    loc.aboutTitle,
    loc.aboutMissionMd,
    loc.seedBackupTitle,
    loc.seedBackupWarning(24),
    loc.seedBackupHiddenTitle,
    loc.seedBackupHiddenDesc,
    loc.seedBackupRevealBtn,
    loc.seedBackupContinueBtn,
    loc.seedVerifyTitle,
    loc.seedVerifyDesc,
    loc.seedVerifyWordLabel(7),
    loc.seedVerifyFailed,
    loc.seedVerifyConfirmBtn,
    loc.receiveTitle,
    loc.receiveDesc,
    loc.receiveError,
    loc.receiveNoWallet,
    loc.receiveCopied,
    loc.receiveOfflineNote,
    loc.recoverTitle,
    loc.recoverDesc,
    loc.recoverWords12,
    loc.recoverWords24,
    loc.recoverInvalidSeed,
    loc.recoverError,
    loc.recoverConfirmBtn,
  ];
}
