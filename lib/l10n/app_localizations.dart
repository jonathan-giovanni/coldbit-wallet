import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'ColdBit Wallet'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure by Isolation'**
  String get onboardingTitle;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Air-Gapped Absolute'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In en, this message translates to:
  /// **'Your keys never touch the internet. Pure PSBT signing disconnected from any network.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Zero Telemetry'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In en, this message translates to:
  /// **'No analytics. No tracking. No third-party servers. Your data is your own.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Fortress Storage'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In en, this message translates to:
  /// **'Protected by Secure Enclave and military-grade encryption patterns.'**
  String get onboardingSlide3Desc;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your private keys never touch the internet. Fully isolated offline PSBT signing vault.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Empty Vault'**
  String get onboardingCreateBtn;

  /// No description provided for @onboardingCreate24Btn.
  ///
  /// In en, this message translates to:
  /// **'Create 24-word Vault'**
  String get onboardingCreate24Btn;

  /// No description provided for @onboardingCreate12Btn.
  ///
  /// In en, this message translates to:
  /// **'Create 12-word Vault'**
  String get onboardingCreate12Btn;

  /// No description provided for @onboardingRecoverBtn.
  ///
  /// In en, this message translates to:
  /// **'Recover Seed'**
  String get onboardingRecoverBtn;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'ColdBit Wallet'**
  String get introTitle;

  /// No description provided for @introSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build an offline Bitcoin vault step by step: understand the operating model, choose the recovery phrase length, prepare the backup, then create the secure PIN.'**
  String get introSubtitle;

  /// No description provided for @introBeginBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Onboarding'**
  String get introBeginBtn;

  /// No description provided for @introRecoverBtn.
  ///
  /// In en, this message translates to:
  /// **'Recover existing vault'**
  String get introRecoverBtn;

  /// No description provided for @briefingTitle.
  ///
  /// In en, this message translates to:
  /// **'Operational Briefing'**
  String get briefingTitle;

  /// No description provided for @briefingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ColdBit is built for isolated PSBT review and signing. These rules define how the vault must be used before any seed exists.'**
  String get briefingSubtitle;

  /// No description provided for @briefingOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the signer offline'**
  String get briefingOfflineTitle;

  /// No description provided for @briefingOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'Private keys stay on this device. Move unsigned and signed transactions by QR or file transfer only.'**
  String get briefingOfflineDesc;

  /// No description provided for @briefingSeedTitle.
  ///
  /// In en, this message translates to:
  /// **'The seed is the vault'**
  String get briefingSeedTitle;

  /// No description provided for @briefingSeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Anyone with the recovery phrase can move funds. Write it once, verify it, and store it outside digital systems.'**
  String get briefingSeedDesc;

  /// No description provided for @briefingPsbtTitle.
  ///
  /// In en, this message translates to:
  /// **'Review every PSBT'**
  String get briefingPsbtTitle;

  /// No description provided for @briefingPsbtDesc.
  ///
  /// In en, this message translates to:
  /// **'Treat each imported transaction as hostile until the destination, totals, and signing context have been checked.'**
  String get briefingPsbtDesc;

  /// No description provided for @briefingContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get briefingContinueBtn;

  /// No description provided for @vaultModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Vault Mode'**
  String get vaultModeTitle;

  /// No description provided for @vaultModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new isolated wallet or restore a known recovery phrase. Creation always forces a backup verification path.'**
  String get vaultModeSubtitle;

  /// No description provided for @vaultModeCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create new vault'**
  String get vaultModeCreateTitle;

  /// No description provided for @vaultModeCreateDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate a fresh BIP39 recovery phrase locally and protect it with a PIN.'**
  String get vaultModeCreateDesc;

  /// No description provided for @vaultModeRecoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover existing vault'**
  String get vaultModeRecoverTitle;

  /// No description provided for @vaultModeRecoverDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 12-word or 24-word BIP39 phrase and restore the signing vault.'**
  String get vaultModeRecoverDesc;

  /// No description provided for @vaultModeCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create new vault'**
  String get vaultModeCreateBtn;

  /// No description provided for @vaultModeRecoverBtn.
  ///
  /// In en, this message translates to:
  /// **'Recover vault'**
  String get vaultModeRecoverBtn;

  /// No description provided for @mnemonicLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Phrase Length'**
  String get mnemonicLengthTitle;

  /// No description provided for @mnemonicLengthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the exact seed size before generation. ColdBit will use your selection when the phrase is created.'**
  String get mnemonicLengthSubtitle;

  /// No description provided for @mnemonicLength24Title.
  ///
  /// In en, this message translates to:
  /// **'24 words'**
  String get mnemonicLength24Title;

  /// No description provided for @mnemonicLength24Desc.
  ///
  /// In en, this message translates to:
  /// **'Maximum entropy for high-value cold storage and institutional workflows.'**
  String get mnemonicLength24Desc;

  /// No description provided for @mnemonicLength12Title.
  ///
  /// In en, this message translates to:
  /// **'12 words'**
  String get mnemonicLength12Title;

  /// No description provided for @mnemonicLength12Desc.
  ///
  /// In en, this message translates to:
  /// **'Standard BIP39 strength with shorter manual backup and recovery.'**
  String get mnemonicLength12Desc;

  /// No description provided for @mnemonicLengthContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Prepare backup'**
  String get mnemonicLengthContinueBtn;

  /// No description provided for @backupDisciplineTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup Discipline'**
  String get backupDisciplineTitle;

  /// No description provided for @backupDisciplineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare the physical environment now. The next phase creates the real recovery phrase.'**
  String get backupDisciplineSubtitle;

  /// No description provided for @backupDisciplinePaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Use physical media'**
  String get backupDisciplinePaperTitle;

  /// No description provided for @backupDisciplinePaperDesc.
  ///
  /// In en, this message translates to:
  /// **'Prepare paper or metal backup material before revealing the phrase.'**
  String get backupDisciplinePaperDesc;

  /// No description provided for @backupDisciplinePrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Control the room'**
  String get backupDisciplinePrivacyTitle;

  /// No description provided for @backupDisciplinePrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'No cameras, observers, screen sharing, or remote support during seed creation.'**
  String get backupDisciplinePrivacyDesc;

  /// No description provided for @backupDisciplineNoPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Never photograph it'**
  String get backupDisciplineNoPhotoTitle;

  /// No description provided for @backupDisciplineNoPhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'Do not store the phrase in photos, password managers, cloud notes, email, or chat.'**
  String get backupDisciplineNoPhotoDesc;

  /// No description provided for @backupDisciplineStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Separate storage'**
  String get backupDisciplineStorageTitle;

  /// No description provided for @backupDisciplineStorageDesc.
  ///
  /// In en, this message translates to:
  /// **'Store the backup where it survives device loss and cannot be casually discovered.'**
  String get backupDisciplineStorageDesc;

  /// No description provided for @backupDisciplineContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Create secure PIN'**
  String get backupDisciplineContinueBtn;

  /// No description provided for @pinSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault Access'**
  String get pinSetupTitle;

  /// No description provided for @pinSetupCreateMsg.
  ///
  /// In en, this message translates to:
  /// **'Establish your Secure PIN'**
  String get pinSetupCreateMsg;

  /// No description provided for @pinSetupConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Confirm your Secure PIN'**
  String get pinSetupConfirmMsg;

  /// No description provided for @pinSetupHintCreate.
  ///
  /// In en, this message translates to:
  /// **'Choose a 6-digit access code'**
  String get pinSetupHintCreate;

  /// No description provided for @pinSetupHintConfirm.
  ///
  /// In en, this message translates to:
  /// **'Repeat the code to verify accuracy'**
  String get pinSetupHintConfirm;

  /// No description provided for @pinSetupMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinSetupMismatch;

  /// No description provided for @biometricOptinTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Defense'**
  String get biometricOptinTitle;

  /// No description provided for @biometricOptinDesc.
  ///
  /// In en, this message translates to:
  /// **'Accelerate your Vault access by linking your biological signature. This feature is completely optional and your Face ID/Touch ID never leaves your physical device.'**
  String get biometricOptinDesc;

  /// No description provided for @biometricOptinReason.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometrics for ColdBit Vault'**
  String get biometricOptinReason;

  /// No description provided for @biometricOptinSkipBtn.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get biometricOptinSkipBtn;

  /// No description provided for @biometricOptinConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get biometricOptinConfirmBtn;

  /// No description provided for @vaultUnlockAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get vaultUnlockAccessDenied;

  /// No description provided for @vaultUnlockEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN Code'**
  String get vaultUnlockEnterPin;

  /// No description provided for @vaultUnlockStartSetup.
  ///
  /// In en, this message translates to:
  /// **'Create or recover wallet'**
  String get vaultUnlockStartSetup;

  /// No description provided for @vaultUnlockStartSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Use this if you want to start the onboarding flow again on this device.'**
  String get vaultUnlockStartSetupDesc;

  /// No description provided for @vaultUnlockLockedWait.
  ///
  /// In en, this message translates to:
  /// **'LOCKED. Wait {seconds}s'**
  String vaultUnlockLockedWait(int seconds);

  /// No description provided for @dashboardVaultLbl.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get dashboardVaultLbl;

  /// No description provided for @dashboardStatusLbl.
  ///
  /// In en, this message translates to:
  /// **'Air-Gapped'**
  String get dashboardStatusLbl;

  /// No description provided for @dashboardMfLbl.
  ///
  /// In en, this message translates to:
  /// **'Master Fingerprint'**
  String get dashboardMfLbl;

  /// No description provided for @dashboardNetworkLbl.
  ///
  /// In en, this message translates to:
  /// **'Native SegWit'**
  String get dashboardNetworkLbl;

  /// No description provided for @dashboardAuthLog.
  ///
  /// In en, this message translates to:
  /// **'Auth Log'**
  String get dashboardAuthLog;

  /// No description provided for @dashboardSentBtc.
  ///
  /// In en, this message translates to:
  /// **'Sent {amount} BTC'**
  String dashboardSentBtc(String amount);

  /// No description provided for @dashboardReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Sign'**
  String get dashboardReadyTitle;

  /// No description provided for @dashboardReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan a Partially Signed Bitcoin Transaction (PSBT) to authorize it offline within the enclave.'**
  String get dashboardReadyDesc;

  /// No description provided for @dashboardScanBtn.
  ///
  /// In en, this message translates to:
  /// **'Scan PSBT Ticket'**
  String get dashboardScanBtn;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Vault Settings'**
  String get drawerSettings;

  /// No description provided for @drawerAbout.
  ///
  /// In en, this message translates to:
  /// **'About ColdBit'**
  String get drawerAbout;

  /// No description provided for @drawerFallback.
  ///
  /// In en, this message translates to:
  /// **'Fallback'**
  String get drawerFallback;

  /// No description provided for @drawerLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get drawerLastUpdate;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language / Idioma'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'English • Español'**
  String get settingsLanguageDesc;

  /// No description provided for @settingsCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera (QR Scanner)'**
  String get settingsCamera;

  /// No description provided for @settingsCameraDesc.
  ///
  /// In en, this message translates to:
  /// **'Required to import open network PSBTs'**
  String get settingsCameraDesc;

  /// No description provided for @settingsPush.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsPush;

  /// No description provided for @settingsPushDesc.
  ///
  /// In en, this message translates to:
  /// **'Local alerts for scans or jailbreak detections'**
  String get settingsPushDesc;

  /// No description provided for @settingsBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get settingsBiometrics;

  /// No description provided for @settingsBiometricsDesc.
  ///
  /// In en, this message translates to:
  /// **'Replaces manual PIN typing on quick unlocks'**
  String get settingsBiometricsDesc;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Project'**
  String get aboutTitle;

  /// No description provided for @aboutMissionMd.
  ///
  /// In en, this message translates to:
  /// **'# ColdBit Wallet Mission\n\nThis application was forged with an absolute purpose: **Assume that all internet environments are compromised or inherently hostile**.\n\n## Design Principles\n1. **Pure Air-gapped**: \n   Your device will not send a single private key to the open internet. Only PSBT signing.\n2. **RAM Layer Defense (MemGuard)**: \n   Seeds (Seed Phrases) exist in temporary sealed cryptographic RAM. Pulsed and burned at discretion.\n\n---\n\n### Implemented Security Components:\n- **libsodium**: Argon2id style hashing derivation and isolated storage.\n- **Fail-Close Policy**: Any disturbance (exiting the App, biometric failure, detected jailbreak) collapses the session by protocol.\n\n*The software is for sovereign use. Verify the Code Hash and build it yourself.*'**
  String get aboutMissionMd;

  /// No description provided for @seedBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery Phrase'**
  String get seedBackupTitle;

  /// No description provided for @seedBackupWarning.
  ///
  /// In en, this message translates to:
  /// **'Write down these {count} words in order. This is your ONLY way to recover your wallet. Never share them. Never store them digitally.'**
  String seedBackupWarning(int count);

  /// No description provided for @seedBackupHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Phrase Hidden'**
  String get seedBackupHiddenTitle;

  /// No description provided for @seedBackupHiddenDesc.
  ///
  /// In en, this message translates to:
  /// **'Ensure no one can see your screen before revealing your recovery phrase.'**
  String get seedBackupHiddenDesc;

  /// No description provided for @seedBackupRevealBtn.
  ///
  /// In en, this message translates to:
  /// **'Reveal Phrase'**
  String get seedBackupRevealBtn;

  /// No description provided for @seedBackupContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'I Wrote It Down'**
  String get seedBackupContinueBtn;

  /// No description provided for @seedVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Backup'**
  String get seedVerifyTitle;

  /// No description provided for @seedVerifyDesc.
  ///
  /// In en, this message translates to:
  /// **'Select the correct word for each position to confirm you saved your recovery phrase.'**
  String get seedVerifyDesc;

  /// No description provided for @seedVerifyWordLabel.
  ///
  /// In en, this message translates to:
  /// **'Word #{number}'**
  String seedVerifyWordLabel(int number);

  /// No description provided for @seedVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Incorrect selection. Try again.'**
  String get seedVerifyFailed;

  /// No description provided for @seedVerifyConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Backup'**
  String get seedVerifyConfirmBtn;

  /// No description provided for @receiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Receive Address'**
  String get receiveTitle;

  /// No description provided for @receiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Share this address to receive Bitcoin. Verify it matches your hardware wallet before sending funds.'**
  String get receiveDesc;

  /// No description provided for @receiveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to derive address'**
  String get receiveError;

  /// No description provided for @receiveNoWallet.
  ///
  /// In en, this message translates to:
  /// **'No wallet configured'**
  String get receiveNoWallet;

  /// No description provided for @receiveCopied.
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get receiveCopied;

  /// No description provided for @receiveOfflineNote.
  ///
  /// In en, this message translates to:
  /// **'This address was derived offline from your seed. Always verify on your hardware device before accepting large transactions.'**
  String get receiveOfflineNote;

  /// No description provided for @recoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Wallet'**
  String get recoverTitle;

  /// No description provided for @recoverDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your recovery phrase to restore your wallet. Each word must be from the BIP39 standard wordlist.'**
  String get recoverDesc;

  /// No description provided for @recoverWords12.
  ///
  /// In en, this message translates to:
  /// **'12 words'**
  String get recoverWords12;

  /// No description provided for @recoverWords24.
  ///
  /// In en, this message translates to:
  /// **'24 words'**
  String get recoverWords24;

  /// No description provided for @recoverInvalidSeed.
  ///
  /// In en, this message translates to:
  /// **'Invalid recovery phrase. Check each word carefully.'**
  String get recoverInvalidSeed;

  /// No description provided for @recoverError.
  ///
  /// In en, this message translates to:
  /// **'Recovery failed. Please try again.'**
  String get recoverError;

  /// No description provided for @recoverConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Restore Vault'**
  String get recoverConfirmBtn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
