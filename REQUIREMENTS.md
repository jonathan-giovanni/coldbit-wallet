# REQUIREMENTS.md — Coldbit Wallet
**Project:** coldbit-wallet  
**Purpose:** Air-gapped, privacy-first Bitcoin signing wallet — fully offline, no telemetry, no third-party services, no backend.

---

## 1) Philosophy and Core Principles
Coldbit Wallet is a **true cold wallet**: private keys never leave the device, no network access is required, and all signing operations occur locally using hardware-backed secure elements (Android StrongBox / iOS Secure Enclave).  
The app has **zero analytics, zero metrics, and zero external dependencies**.  
It exists to **create, derive, and sign Bitcoin transactions (PSBTs)** using industry-standard cryptographic primitives and BIPs. The only optional data exchange happens via **UR2-encoded QR fragments** or **air-gapped file transfer** — never through third-party servers.

---

## 2) MVP Objectives
- Generate and back up BIP39 mnemonic seeds completely offline.
- Derive deterministic keys according to BIP32/BIP44/BIP84/BIP86 (segwit & taproot).
- Store master keys in hardware-backed secure storage.
- Import, display, sign, and export PSBTs using UR2 QR encoding.
- Enforce dual authentication (8-digit PIN + biometric) before any signing operation.
- Provide a minimal, elegant, dark-themed UX for a premium, privacy-oriented experience.
- Maintain modular, testable architecture — clean separation between UI, ViewModels, Services, and Core utilities.
- Require no backend, no internet connection, and no third-party analytics SDKs.

---

## 3) Non-Negotiable Constraints
- **Offline-first** — no network calls unless explicitly initiated by user for Bitcoin transaction broadcast or manual peer setup.
- **No telemetry** — absolutely no analytics, crash reporters, or ads.
- **No remote login / identity system.**
- **All key material remains local** to the device, protected by StrongBox / Secure Enclave.
- **Auditable and deterministic** — every cryptographic operation should be reproducible and verifiable using public standards.

---

## 4) Bitcoin Standards (BIPs) and Cryptographic Requirements
Coldbit Wallet must adhere strictly to Bitcoin Improvement Proposals (BIPs) to ensure full compatibility and auditability:

| Function | Standard | Description |
|-----------|-----------|-------------|
| Seed generation | **BIP39** | Mnemonic seed phrases and entropy-based generation. |
| Key derivation | **BIP32** | Hierarchical Deterministic (HD) wallet tree structure. |
| Account structure | **BIP44** | Multi-account hierarchy for legacy and segwit wallets. |
| Native SegWit | **BIP84** | Derivation path for bech32 (P2WPKH) addresses. |
| Taproot | **BIP341 / BIP86** | Schnorr key aggregation and derivation paths. |
| Partially Signed Transactions | **BIP174** | PSBT format for multi-stage signing. |
| Descriptor wallets | **BIP380 / BIP385** | Optional future descriptor-based architecture. |
| UR encoding | **UR2** | QR fragment encoding for air-gapped transfer. |

Additional notes:
- Use **Schnorr (BIP340)** for Taproot signatures where supported by hardware.
- Avoid proprietary extensions; maintain strict compliance with reference BIP specifications.
- Document and expose all derivation paths for audit transparency.

---

## 5) Secure Key Storage and Authentication
### Android (Kotlin)
- Use **StrongBox** where available, fallback to **Android Keystore**.
- Expose attestation for local verification and auditing.
- Require **biometric + 8-digit PIN** for signing.
- Native platform channel calls should provide: availability, key generation, signing, attestation export.

### iOS (Swift)
- Use **Secure Enclave** with Keychain integration.
- Expose creation metadata, protection class, and attestation.
- Native methods should provide: availability, key generation, signing, attestation export.

### Shared Security Policy
- Enforce local authentication for each signing session.
- Detect root/jailbreak and block signing if compromised.
- Never export private keys; only PSBT signatures or descriptors.

---

## 6) UX / UI Design Guidelines
### Design System
- **Theme:** Dark premium aesthetic
    - Background: `#0F1115`
    - Surface: `#121417`
    - Text: `#E6E7E8`
    - Accent Orange: `#FF8A00`
    - Accent White: `#F9FAFB`
    - Info Blue: `#2D9CDB`
    - Success Green: `#27AE60`
    - Error Red: `#EB5757`
- **Typography:** Inter (primary), Roboto fallback.
- **Layout:** Minimal chrome, centered titles, subtle elevation, 12dp global corner radius.
- **Interaction:** Micro-animations for buttons, QR progress, status updates.
- **Consistency:** Predefined color roles for all text/status.
- **Accessibility:** Ensure contrast for readability.

### UX Flows
1. **Create Wallet** — Generate BIP39 mnemonic, display securely, enforce manual backup confirmation, lock display after timeout.
2. **Receive** — Display derived address (BIP84/BIP86 path), show QR, copy address; offline-only.
3. **Sign PSBT** — Import PSBT (UR2 QR/file), parse, show transaction summary, request PIN+biometric, sign locally, export UR2 QR.
4. **Settings (optional)** — Manage PIN, attestation info, about/license.

All screens must convey **control, isolation, and security**.

---

## 7) Architecture Overview
- **Pattern:** Clean MVVM (Model–View–ViewModel)
- **State management:** Riverpod for DI and state providers.
- **Persistence:** Sembast (file-based DB).
- **Serialization:** json_serializable for deterministic encoding.
- **Modules & Responsibilities:**
    - `services/secure_storage_service.dart` → Native keychain wrapper
    - `services/psbt_service.dart` → PSBT import/validate/sign
    - `services/ur_service.dart` → Encode/decode UR2 QR fragments (FFI)
    - `services/wallet_service.dart` → BDK/descriptor derivations
- **Isolation layers:**
    - UI/Views → Flutter widgets, declarative/reactive
    - ViewModels → Business logic, state providers
    - Repositories → Persistence, caching
    - Services → Native FFI, crypto, key mgmt
    - Core → Theme, constants, utilities

---

## 8) Dependencies (no fixed versions)
- `flutter_riverpod`
- `flutter_secure_storage`
- `local_auth`
- `mobile_scanner` or `qr_code_scanner`
- `qr_flutter`
- `ffi`
- `json_annotation`, `json_serializable`, `build_runner`
- `sembast`
- `flutter_lints`
- Dev/test: `mockito`, `flutter_test`, `integration_test`

> Only use well-maintained packages with no telemetry.

---

## 9) Native Plugin Requirements
- **Android (Kotlin):** StrongBox / Keystore integration
- **iOS (Swift):** Secure Enclave / Keychain integration
- Provide unified Dart interface for:
    - Availability check
    - Key generation
    - Signing
    - Attestation export

```dart
abstract class SecureKeyStore {
  Future<bool> isHardwareBacked();
  Future<Uint8List> sign(String alias, Uint8List digest);
  Future<Uint8List?> getAttestation(String alias);
}
```
---

## 10) Security Checklist
- All keys remain local and never leave the device.
- Dual authentication enforced: biometric + 8-digit PIN for any signing operation.
- Root/jailbreak detection blocks signing if device compromised.
- PSBT validation and sanity checks before signing.
- Attestation logs must be accessible for auditing purposes.
- FFI calls (UR2, BDK) must be verified against reference implementations.
- Sensitive data in memory must be cleared after use.
- Enforce session timeouts for secure key access.

---

## 11) Testing Plan
- **Unit Tests:** Key derivation, PSBT signing, UR2 encode/decode, FFI wrappers.
- **Integration Tests:** Offline wallet creation, QR import/export, signing flows.
- **Manual / Regtest Scenarios:**
    1. Generate unsigned PSBT on regtest.
    2. Encode to UR2 QR fragments or file.
    3. Scan/import in Coldbit Wallet.
    4. Verify transaction summary.
    5. Authenticate with PIN + biometric.
    6. Sign and export signed UR2 QR/file.
    7. Validate signatures externally.
- **Regression:** Test edge cases for Taproot, SegWit, and legacy derivations.
- **Security:** Attempt signing on rooted/jailbroken devices to ensure blocking.

---

## 12) CI / Build Recommendations
- Run `dart analyze` to enforce code quality and lint rules.
- Execute `flutter test` and `integration_test` for unit and flow validation.
- Use pinned Flutter/Dart SDK versions for reproducible builds.
- Build APK/IPA using local signing keys; optionally GPG-sign artifacts for verification.
- CI pipeline may include:
    - Static code analysis
    - Unit & integration tests
    - Build reproducibility verification
    - Optional artifact archiving

---

## 13) Known Limitations / Next Steps
- MVP supports **offline-only operation**; no automatic network peer discovery or broadcasting.
- Multi-signature, watch-only wallets, and Tor integration are planned for future versions.
- Descriptor-based wallet support (BIP380/BIP385) optional; may require additional UI and FFI wrappers.
- Further UX/interaction polishing can enhance micro-animations and accessibility compliance.
- Hardware attestation and FFI libraries can be extended to support additional platforms and new cryptographic standards.

---

**End of Requirements**
