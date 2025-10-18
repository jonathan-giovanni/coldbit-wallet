[![codecov](https://codecov.io/gh/jonathan-giovanni/coldbit-wallet/branch/main/graph/badge.svg)](https://codecov.io/gh/jonathan-giovanni/coldbit-wallet)

# 🧊 ColdBit Wallet
### Ultra-Secure Bitcoin Cold Storage — Minimal. Anonymous. Local.

---

## 🪙 Overview
ColdBit Wallet is an **offline-first Bitcoin wallet** focused on privacy, autonomy, and security.  
It never connects to any external service other than the Bitcoin network itself.  
All wallet logic — including key management, signing, and seed handling — occurs locally on the device using cryptographic best practices and Bitcoin standards.

---

## ⚙️ Core Features
- **Offline Operation** — No servers, no telemetry, no analytics.
- **BIP Standards Support**
    - `BIP32` — Hierarchical Deterministic (HD) key generation
    - `BIP39` — Mnemonic seed phrases
    - `BIP44` — Multi-account derivation paths
    - `BIP84` — Native SegWit (bech32) support
    - `BIP174` — PSBT (Partially Signed Bitcoin Transactions) support
- **Cold Storage Security**
    - Private keys never leave the device
    - Encrypted storage in Secure Enclave (iOS) / Keystore (Android)
    - Optional air-gapped transaction signing
- **Authentication**
    - 8-digit PIN code
    - Biometric unlock (Face ID / Touch ID / Android Biometrics)
- **Network Configuration**
    - Direct Bitcoin network access (Full Node or SPV mode)
    - Optional Tor proxy for network privacy
- **UX/UI Design**
    - Clean, minimalist interface with a dark-gray + orange theme
    - Clear, focused flows for send/receive operations
    - Zero distractions: no banners, ads, or metrics
    - Intuitive recovery and backup screens with clear warnings
- **Cross-Platform (Flutter)**
    - Native experience for iOS and Android
    - Uses secure platform channels for cryptographic operations

---

## 🧠 Architecture Overview
Flutter (UI + Core Logic)
├── SecureStorage Layer (Keychain / Keystore)
├── Wallet Core (BIP32/BIP39/BIP44/BIP84 implementations)
├── Transaction Engine (PSBT handling, signing)
├── Network Module (Bitcoin P2P / SPV)
└── UI Layer (Reactive, Clean Architecture)

**Design Principles:**
- KISS (Keep It Simple & Secure)
- No third-party dependencies that risk privacy
- Clean code, high cohesion, and testability
- 100% user data control

---

## 🔐 Security Model
- All cryptographic keys generated **on-device**, using OS-secure RNG.
- AES-256 encryption for sensitive data at rest.
- No cloud backups — recovery via mnemonic only.
- Biometric + PIN required for any signing operation.
- Optional air-gap mode (manual QR-based PSBT exchange).

---

## 🧩 Development Setup
**Requirements**
- Flutter SDK
- Android Studio / Xcode
- Dart ≥ latest stable
- Bitcoin testnet/full node for validation

**Run:**
```bash
flutter pub get
flutter run
```

## ⚖️ License

This project is released under the Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
See [LICENSE.md](./LICENSE.md) for details.


