# ColdBit Wallet - Project Description

ColdBit Wallet is a Flutter-based Bitcoin cold-signing wallet for iOS and Android.

The product goal is an offline-first, privacy-focused signing vault where seed generation, key derivation, transaction review, and PSBT signing happen locally on the device. The intended production model is no backend, no telemetry, no remote identity, and air-gapped transaction transfer through QR.

Current implementation status:

- The app implements a substantial Flutter UI and onboarding/vault flow.
- BIP39 24-word generation, validation, backup, verification, and recovery are present.
- BIP84 descriptor derivation and PSBT signing are connected through `bdk_flutter`.
- PIN hashing, rate limiting, local secure storage, biometric unlock, and lifecycle protection are present.

Production hardening still required:

- Real receive address derivation must replace the current fingerprint placeholder.
- PSBT transaction review must parse real outputs, fee, and amount.
- Signing must fail closed and never export an unsigned payload as signed.
- 12/24-word mnemonic policy must be implemented if both are claimed.
- UR2 QR fragmentation, Taproot/BIP86, native hardware attestation, and network/broadcast features are planned, not complete.

Until the production gates in `docs/PRODUCTION_EXECUTION_PLAN.md` are complete, this repository should be treated as a hardening-stage MVP, not a wallet for real funds or institutional deployment.
