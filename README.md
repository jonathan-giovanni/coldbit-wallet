[![codecov](https://codecov.io/gh/jonathan-giovanni/coldbit-wallet/branch/develop/graph/badge.svg)](https://codecov.io/gh/jonathan-giovanni/coldbit-wallet/branch/develop)

# ColdBit Wallet

Bitcoin cold-signing wallet for iOS and Android, built with Flutter.

ColdBit is designed to become an offline-first Bitcoin signing vault: local seed generation, local key derivation, PSBT review, local signing, and QR-based air-gapped transfer. The repository is currently in hardening toward a production MVP. It must not be used with real funds until the production gates in `docs/PRODUCTION_EXECUTION_PLAN.md` are complete.

## Current Implementation

- Flutter mobile app with dark security-focused UI.
- Onboarding, PIN setup, vault unlock, settings, about, dashboard, receive, seed backup, seed verification, and seed recovery screens.
- BIP39 24-word mnemonic generation and validation.
- BIP39 recovery input with smart paste and word suggestions.
- BIP84 descriptor derivation through `bdk_flutter`.
- Testnet wallet provider scaffold.
- QR scanner for raw PSBT payloads.
- PSBT parsing/signing path connected to BDK.
- PIN hashing through libsodium.
- Local secure storage through `flutter_secure_storage`.
- Biometric unlock support through `local_auth`.
- In-memory sealed state helper for sensitive values.
- Root/jailbreak detection scaffolding.
- EN/ES localization.

## Not Production Complete Yet

The following items are planned or partially implemented and must be completed before production use:

- Receive address derivation is not production-ready: the current screen must be changed to display a real Bitcoin address, not a wallet fingerprint.
- PSBT review is not production-ready: transaction amount and fee review must be parsed from the PSBT, not mocked.
- Signing must fail closed: a failed signing attempt must never export the original unsigned PSBT as if it were signed.
- Seed length selection is not implemented yet: creation and recovery currently assume 24 words.
- UR2 animated QR import/export is not implemented yet.
- Taproot/BIP86 support is not implemented yet.
- Native StrongBox/Secure Enclave attestation is not implemented yet; current storage uses OS secure storage via Flutter plugins.
- Network broadcast, Tor, SPV, full-node connectivity, multisig, watch-only wallets, and descriptor export are not production features yet.

## Architecture

```text
Flutter UI
  -> Riverpod providers
  -> Wallet/seed/security services
  -> bdk_flutter, bip39, libsodium, local_auth, flutter_secure_storage
```

Main code areas:

- `lib/core/crypto`: mnemonic, descriptor, PSBT parsing/signing helpers.
- `lib/core/providers`: Riverpod app state.
- `lib/core/security`: PIN, rate limiting, secure storage, lifecycle, threat checks.
- `lib/presentation/screens`: app flows.
- `lib/presentation/widgets`: reusable UI controls.
- `lib/l10n`: generated localization files and ARB inputs.
- `test`: unit and widget tests.

## Quality Gate

Every production change must pass:

```bash
dart format .
flutter analyze
flutter test --coverage
flutter build apk --debug
```

Current local coverage gate: `75.21%` line coverage from `coverage/lcov.info`
on 2026-05-02. Minimum required coverage: `70%`.

The execution roadmap is maintained in:

- `docs/PRODUCTION_EXECUTION_PLAN.md`
- `docs/QUALITY_BASELINE.md`

## Development Setup

Requirements:

- Flutter SDK
- Android Studio and/or Xcode
- Dart SDK matching the Flutter toolchain

Run:

```bash
flutter pub get
flutter run
```

Test:

```bash
flutter analyze
flutter test --coverage
```

## License

This project is released under the Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0). See `LICENSE.md`.
