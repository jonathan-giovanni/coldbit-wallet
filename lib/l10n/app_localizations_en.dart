// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ColdBit Wallet';

  @override
  String get onboardingTitle => 'Secure by Isolation';

  @override
  String get onboardingSlide1Title => 'Air-Gapped Absolute';

  @override
  String get onboardingSlide1Desc =>
      'Your keys never touch the internet. Pure PSBT signing disconnected from any network.';

  @override
  String get onboardingSlide2Title => 'Zero Telemetry';

  @override
  String get onboardingSlide2Desc =>
      'No analytics. No tracking. No third-party servers. Your data is your own.';

  @override
  String get onboardingSlide3Title => 'Fortress Storage';

  @override
  String get onboardingSlide3Desc =>
      'Protected by Secure Enclave and military-grade encryption patterns.';

  @override
  String get onboardingSubtitle =>
      'Your private keys never touch the internet. Fully isolated offline PSBT signing vault.';

  @override
  String get onboardingCreateBtn => 'Create Empty Vault';

  @override
  String get onboardingCreate24Btn => 'Create 24-word Vault';

  @override
  String get onboardingCreate12Btn => 'Create 12-word Vault';

  @override
  String get onboardingRecoverBtn => 'Recover Seed';

  @override
  String get pinSetupTitle => 'Vault Access';

  @override
  String get pinSetupCreateMsg => 'Establish your Secure PIN';

  @override
  String get pinSetupConfirmMsg => 'Confirm your Secure PIN';

  @override
  String get pinSetupHintCreate => 'Choose a 6-digit access code';

  @override
  String get pinSetupHintConfirm => 'Repeat the code to verify accuracy';

  @override
  String get pinSetupMismatch => 'PINs do not match';

  @override
  String get biometricOptinTitle => 'Biometric Defense';

  @override
  String get biometricOptinDesc =>
      'Accelerate your Vault access by linking your biological signature. This feature is completely optional and your Face ID/Touch ID never leaves your physical device.';

  @override
  String get biometricOptinReason => 'Enable Biometrics for ColdBit Vault';

  @override
  String get biometricOptinSkipBtn => 'Skip';

  @override
  String get biometricOptinConfirmBtn => 'Confirm';

  @override
  String get vaultUnlockAccessDenied => 'Access Denied';

  @override
  String get vaultUnlockEnterPin => 'Enter PIN Code';

  @override
  String vaultUnlockLockedWait(int seconds) {
    return 'LOCKED. Wait ${seconds}s';
  }

  @override
  String get dashboardVaultLbl => 'Vault';

  @override
  String get dashboardStatusLbl => 'Air-Gapped';

  @override
  String get dashboardMfLbl => 'Master Fingerprint';

  @override
  String get dashboardNetworkLbl => 'Native SegWit';

  @override
  String get dashboardAuthLog => 'Auth Log';

  @override
  String dashboardSentBtc(String amount) {
    return 'Sent $amount BTC';
  }

  @override
  String get dashboardReadyTitle => 'Ready to Sign';

  @override
  String get dashboardReadyDesc =>
      'Scan a Partially Signed Bitcoin Transaction (PSBT) to authorize it offline within the enclave.';

  @override
  String get dashboardScanBtn => 'Scan PSBT Ticket';

  @override
  String get drawerSettings => 'Vault Settings';

  @override
  String get drawerAbout => 'About ColdBit';

  @override
  String get drawerFallback => 'Fallback';

  @override
  String get drawerLastUpdate => 'Last Update';

  @override
  String get settingsTitle => 'Vault Settings';

  @override
  String get settingsLanguage => 'Language / Idioma';

  @override
  String get settingsLanguageDesc => 'English • Español';

  @override
  String get settingsCamera => 'Camera (QR Scanner)';

  @override
  String get settingsCameraDesc => 'Required to import open network PSBTs';

  @override
  String get settingsPush => 'Push Notifications';

  @override
  String get settingsPushDesc =>
      'Local alerts for scans or jailbreak detections';

  @override
  String get settingsBiometrics => 'Biometric Authentication';

  @override
  String get settingsBiometricsDesc =>
      'Replaces manual PIN typing on quick unlocks';

  @override
  String get aboutTitle => 'About the Project';

  @override
  String get aboutMissionMd =>
      '# ColdBit Wallet Mission\n\nThis application was forged with an absolute purpose: **Assume that all internet environments are compromised or inherently hostile**.\n\n## Design Principles\n1. **Pure Air-gapped**: \n   Your device will not send a single private key to the open internet. Only PSBT signing.\n2. **RAM Layer Defense (MemGuard)**: \n   Seeds (Seed Phrases) exist in temporary sealed cryptographic RAM. Pulsed and burned at discretion.\n\n---\n\n### Implemented Security Components:\n- **libsodium**: Argon2id style hashing derivation and isolated storage.\n- **Fail-Close Policy**: Any disturbance (exiting the App, biometric failure, detected jailbreak) collapses the session by protocol.\n\n*The software is for sovereign use. Verify the Code Hash and build it yourself.*';

  @override
  String get seedBackupTitle => 'Recovery Phrase';

  @override
  String seedBackupWarning(int count) {
    return 'Write down these $count words in order. This is your ONLY way to recover your wallet. Never share them. Never store them digitally.';
  }

  @override
  String get seedBackupHiddenTitle => 'Phrase Hidden';

  @override
  String get seedBackupHiddenDesc =>
      'Ensure no one can see your screen before revealing your recovery phrase.';

  @override
  String get seedBackupRevealBtn => 'Reveal Phrase';

  @override
  String get seedBackupContinueBtn => 'I Wrote It Down';

  @override
  String get seedVerifyTitle => 'Verify Backup';

  @override
  String get seedVerifyDesc =>
      'Select the correct word for each position to confirm you saved your recovery phrase.';

  @override
  String seedVerifyWordLabel(int number) {
    return 'Word #$number';
  }

  @override
  String get seedVerifyFailed => 'Incorrect selection. Try again.';

  @override
  String get seedVerifyConfirmBtn => 'Confirm Backup';

  @override
  String get receiveTitle => 'Receive Address';

  @override
  String get receiveDesc =>
      'Share this address to receive Bitcoin. Verify it matches your hardware wallet before sending funds.';

  @override
  String get receiveError => 'Failed to derive address';

  @override
  String get receiveNoWallet => 'No wallet configured';

  @override
  String get receiveCopied => 'Address copied to clipboard';

  @override
  String get receiveOfflineNote =>
      'This address was derived offline from your seed. Always verify on your hardware device before accepting large transactions.';

  @override
  String get recoverTitle => 'Recover Wallet';

  @override
  String get recoverDesc =>
      'Enter your recovery phrase to restore your wallet. Each word must be from the BIP39 standard wordlist.';

  @override
  String get recoverWords12 => '12 words';

  @override
  String get recoverWords24 => '24 words';

  @override
  String get recoverInvalidSeed =>
      'Invalid recovery phrase. Check each word carefully.';

  @override
  String get recoverError => 'Recovery failed. Please try again.';

  @override
  String get recoverConfirmBtn => 'Restore Vault';
}
