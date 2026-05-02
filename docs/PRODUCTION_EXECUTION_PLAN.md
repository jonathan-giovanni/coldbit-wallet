# ColdBit Wallet - Plan Maestro de Ejecucion Productiva

Fecha de auditoria: 2026-05-02  
Rama auditada: `develop`  
Objetivo: convertir ColdBit Wallet desde prototipo/MVP parcial a aplicacion productiva real, verificable y coherente con lo prometido en README/REQUIREMENTS.  
Modo de trabajo: baby steps, ramas cortas `feature/xx-yyy-zzz`, commits pequenos, pruebas obligatorias por tarea, cobertura creciente y cero tolerancia a codigo quemado que afecte dinero, claves, PSBT o seguridad.

## 0. Regla Suprema

La aplicacion no debe afirmar que hace algo que no hace.

Si una capacidad no esta implementada, auditada y probada, debe estar una de estas dos cosas:

1. Fuera del README, fuera del texto de producto y fuera de la UI.
2. Marcada explicitamente como no disponible en produccion.

No se permite UX de "parece firmado", "parece direccion", "parece hardware-backed", "parece PSBT real" si el dato no es real.

## 1. Estado Actual Confirmado

### 1.1 Git

Repositorio limpio en la auditoria inicial.

Rama actual:

```bash
git branch --show-current
# develop
```

Tracking:

```bash
git status --short --branch
# ## develop...origin/develop
```

Ultimo commit:

```text
9873373 feat(recovery): implement luxury BIP39 recovery flow with smart-paste and suggestions
```

### 1.2 Calidad actual

Tests:

```bash
flutter test
```

Resultado observado: 22 tests pasan, 1 test omitido por BDK native FFI.

Analisis:

```bash
flutter analyze
```

Resultado observado: 5 issues.

Issues:

- `lib/core/crypto/wallet_engine.dart`: import interno de `bip39/src/wordlists/english.dart`.
- `lib/presentation/screens/seed_recovery_screen.dart`: uso innecesario de multiples underscores.
- `test/presentation/screens/seed_recovery_test.dart`: imports no usados.
- `test/presentation/screens/seed_recovery_test.dart`: orden de imports.

### 1.3 Tamano actual

- 45 ficheros Dart en `lib`.
- 7 ficheros Dart en `test`.
- Aproximadamente 6.284 lineas en `lib`.
- Aproximadamente 350 lineas en `test`.

## 2. Promesas del Proyecto vs Implementacion Real

### 2.1 Prometido y parcialmente implementado

| Promesa | Estado real | Accion requerida |
| --- | --- | --- |
| Wallet offline-first | Parcial. No hay backend visible, pero tampoco hay guardas formales anti-network. | Crear politica explicita de red, permisos y tests de ausencia de dependencias de red no autorizadas. |
| BIP39 | Implementado para 24 palabras y validacion. | Parametrizar 12/24 palabras, eliminar import interno de wordlist, tests con vectores reales. |
| BIP84 | Parcial con `bdk_flutter`. | Derivar direcciones reales, xpub/descriptores auditables y path correcto por red. |
| PSBT BIP174 | Parse/sign parcial. | Parsear importes/fees/outputs reales, fallar cerrado, tests con PSBT fixtures reales. |
| PIN | Implementado con hash sodium. | Revisar longitud declarada, intentos, bloqueo, wipe y cobertura. |
| Biometria | Implementada como bypass/opcion. | Definir modelo exacto: PIN + biometria o PIN OR biometria. La promesa actual dice dual auth para firma. |
| Secure storage | Implementado con `flutter_secure_storage`. | No llamarlo Secure Enclave/StrongBox real hasta tener plugin nativo y attestation. |
| i18n EN/ES | Implementado. | Corregir textos que prometen mas de lo implementado. |

### 2.2 Prometido y no implementado

| Promesa | Estado real | Decision productiva |
| --- | --- | --- |
| UR2 QR fragmentado | No existe servicio UR2. | Implementar o retirar de promesas de MVP. |
| Taproot/BIP86 | No implementado. | Fase posterior a BIP84 productivo; no mezclar con MVP si no hay fixtures. |
| StrongBox/Secure Enclave con attestation | No implementado a nivel nativo real. | Crear interfaz y plugins nativos, o degradar texto a "OS secure storage". |
| Direccion real Receive | No implementado. Usa fingerprint como direccion. | Bloqueador P0. |
| TransactionAnalyzer real | No implementado. Usa fee/amount mock. | Bloqueador P0. |
| Broadcast/red Bitcoin | No implementado. | Si cold wallet air-gapped pura, quitar promesa de red directa. |
| Sembast/persistencia DB | Requisito menciona, codigo usa secure storage JSON. | Decidir persistencia minima; no meter DB si KISS no lo exige. |
| Seleccion 12/24 palabras | No implementado. Esta hardcoded a 24 palabras. | Implementar configuracion seed strength antes de produccion. |

## 3. Codigo Quemado, Mock o Peligroso

### 3.1 Bloqueadores P0

#### P0-001: Receive usa fingerprint como direccion Bitcoin

Fichero:

- `lib/presentation/screens/receive_screen.dart`

Codigo actual:

```dart
final address = wallet.fingerprint;
```

Problema:

- Un fingerprint no es una direccion Bitcoin.
- El QR de Receive puede inducir al usuario a enviar fondos a un dato no spendable.
- Esto invalida la pantalla Receive para produccion.

Accion:

- Extender `WalletState` para exponer `receiveAddress`.
- Derivar address real con BDK wallet/descriptor.
- Mostrar path usado, red y formato.
- Testear que testnet produce `tb1...` y mainnet produce `bc1...`.

No hacer:

- No renombrar fingerprint a address.
- No mostrar hashes internos como direccion.
- No permitir Receive si no se pudo derivar direccion real.

#### P0-002: TransactionAnalyzer devuelve amounts y fee mock

Fichero:

- `lib/core/crypto/transaction_analyzer.dart`

Codigo actual:

```dart
feeBtc: 0.000045
totalAmountBtc: 0.024000
```

Problema:

- La pantalla de aprobacion muestra datos financieros falsos.
- Un usuario puede firmar sin ver output real, fee real o destino real.
- Es inadmisible en una wallet productiva.

Accion:

- Reemplazar analyzer por parser real de PSBT.
- Exponer outputs externos, change outputs, inputs, fee, warnings.
- Si BDK no expone lo necesario, crear parser PSBT minimo con fixtures o usar libreria mantenida.
- Fallar cerrado si no se puede calcular destino, fee o amount.

No hacer:

- No usar hashes fake.
- No usar valores ejemplo.
- No firmar PSBT si el resumen no es verificable.

#### P0-003: Firma fallida puede continuar con PSBT original

Fichero:

- `lib/presentation/screens/psbt_review_screen.dart`

Problema:

- Si `WalletEngine.signPsbtOffline` falla, el catch asigna `signedBase64 = widget.rawPsbtBase64`.
- El usuario termina en visualizador QR aunque no haya firma real.

Accion:

- Eliminar fallback.
- Mostrar error irreversible en UI.
- No guardar historial si no hubo firma.
- Testear excepcion y asegurar que no navega a QR firmado.

No hacer:

- No atrapar excepciones de firma sin registrar estado visible.
- No devolver payload original como "signed".

#### P0-004: Recovery y backup hardcoded a 24 palabras

Ficheros:

- `lib/core/crypto/wallet_engine.dart`
- `lib/presentation/screens/seed_backup_screen.dart`
- `lib/presentation/screens/seed_recovery_screen.dart`
- `lib/presentation/screens/seed_verify_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_es.arb`

Problema:

- El producto no permite elegir 12/24 palabras.
- Recovery fuerza 24 controllers.
- Textos prometen 24 siempre.
- El usuario menciona explicitamente seleccion de 12 palabras; no existe.

Accion:

- Crear `SeedStrength` o `MnemonicLength` con 12/24.
- `12 -> strength 128`.
- `24 -> strength 256`.
- Persistir metadata de wallet: mnemonic length, network, derivation policy.
- Hacer recovery dinamico para 12 o 24.
- Validar mnemonic real por checksum.

No hacer:

- No aceptar 12 palabras en UI si luego internamente se trata como 24.
- No guardar preferencias en strings sueltos sin modelo.

#### P0-005: Dual auth no coincide exactamente con promesa

Ficheros:

- `lib/core/security/auth_barrier.dart`
- `lib/presentation/widgets/auth_challenge_sheet.dart`
- `lib/core/providers/auth_provider.dart`

Problema:

- README/REQUIREMENTS hablan de PIN + biometria antes de firmar.
- Codigo permite biometria-only en challenge si esta habilitada.
- PIN autentica sin biometria obligatoria.

Accion:

- Definir politica real:
  - Produccion fuerzas del estado: firma requiere PIN valido y biometria valida en la misma sesion.
  - Unlock puede permitir PIN o biometria segun configuracion.
  - Signing nunca debe ser biometria-only si se promete dual auth.
- Crear `SigningAuthPolicy`.
- Testear combinaciones: PIN ok + biometria ok, PIN ok + biometria fail, PIN fail + biometria ok.

No hacer:

- No usar biometria como sustituto silencioso de PIN para firma.
- No usar textos "dual" si la implementacion es OR.

### 3.2 Bloqueadores P1

#### P1-001: Red hardcoded a testnet

Fichero:

- `lib/core/providers/wallet_provider.dart`

Codigo actual:

```dart
const network = Network.testnet;
```

Problema:

- No existe seleccion/configuracion clara de red.
- UI muestra path `m/84'/0'/0'`, asociado a mainnet, mientras se usa testnet.

Accion:

- Crear `WalletNetworkConfig`.
- Persistir red elegida.
- Mostrar red en UI.
- Path BIP84 correcto:
  - mainnet: `m/84'/0'/0'`
  - testnet/signet/regtest: `m/84'/1'/0'`

#### P1-002: Wordlist BIP39 importada desde `src`

Fichero:

- `lib/core/crypto/wallet_engine.dart`

Problema:

- Importa API privada de otro paquete: `package:bip39/src/wordlists/english.dart`.
- Puede romper en update.

Accion:

- Crear wordlist propia auditada como asset/source versionado, o usar API publica.
- Tests de palabra valida/invalida.
- Documentar checksum de wordlist si se versiona localmente.

#### P1-003: History guardado en secure storage como JSON

Fichero:

- `lib/core/providers/history_provider.dart`

Problema:

- Comentario dice hardware keystore, pero es secure storage.
- Historial no distingue firmado/fallido/exportado.
- No hay txid real.

Accion:

- Crear modelo `SignedTransactionRecord`.
- Guardar solo cuando firma fue real.
- Incluir PSBT fingerprint/hash, timestamp, network, outputs, fee, sign status.

#### P1-004: Root/jailbreak policy dispersa

Ficheros:

- `lib/core/security/threat_detector.dart`
- `lib/core/security/root_detector.dart`
- `lib/core/security/threat_policy.dart`
- `lib/core/security/app_lifecycle_guard.dart`

Problema:

- Hay dos detectores (`safe_device` y `flutter_jailbreak_detection`).
- La policy existe, pero no se aplica de forma centralizada a firma.

Accion:

- Unificar en `ThreatService`.
- Antes de firmar: evaluar policy.
- Si compromised y policy strict: bloquear firma.
- Tests con service fake.

### 3.3 P2 - Deuda estructural

#### P2-001: Carpetas nativas duplicadas

Rutas:

- `android/android`
- `ios/ios`

Problema:

- Confunde build, revision y mantenimiento.

Accion:

- Confirmar si son generadas por error.
- Eliminar en rama separada si no se usan.
- Verificar builds Android/iOS despues.

#### P2-002: L10n generado versionado

Rutas:

- `lib/l10n/app_localizations*.dart`

Decision:

- Si el repo versiona generados, mantener consistente.
- Si se decide no versionar generados, ajustar `.gitignore` y CI.
- No mezclar esta decision con cambios funcionales.

## 4. Mapa Fichero por Fichero

### 4.1 Entrada y configuracion

#### `lib/main.dart`

Responsabilidad:

- Inicializa Flutter, MemGuard, ThreatDetector, UI overlay, orientacion, ProviderScope, lifecycle guard y app.

Estado:

- Correcto como bootstrap.
- Comentario mixto EN/ES menor.

Riesgo:

- `ThreatDetector.init()` inicializa notificaciones, pero la decision de bloquear o no operaciones no esta centralizada.

Accion:

- Mantener simple.
- No meter logica de negocio aqui.

Tests:

- Widget smoke test de arranque.

#### `lib/core/config/vault_config.dart`

Responsabilidad:

- Constantes de vault: PIN length, intentos, timeouts.

Accion:

- Debe convertirse en fuente unica para politica PIN y session timeout.
- No duplicar numeros magicos en pantallas.

#### `pubspec.yaml`

Responsabilidad:

- Dependencias y assets.

Accion:

- Auditar dependencias para telemetria.
- Pinar versiones compatibles.
- No agregar librerias crypto sin razon y sin tests.

### 4.2 Crypto

#### `lib/core/crypto/wallet_engine.dart`

Responsabilidad actual:

- Generar mnemonic 256-bit.
- Validar mnemonic.
- Validar/sugerir palabras BIP39.
- Derivar descriptor BIP84.
- Parsear PSBT.
- Firmar PSBT offline.

Problemas:

- Solo genera 24 palabras.
- Importa wordlist privada.
- No deriva address.
- No expone xpub o descriptor publico para auditoria.
- `signPsbtOffline` no devuelve objeto rico; devuelve base64.

Accion:

- Separar responsabilidades:
  - `MnemonicService`.
  - `WalletDescriptorService`.
  - `PsbtSigner`.
- Mantener KISS: separar solo donde baje riesgo y aumente testabilidad.
- Introducir modelos pequenos:
  - `MnemonicStrength.words12/words24`.
  - `DerivedWallet`.
  - `SignedPsbtResult`.

Tests obligatorios:

- 12 palabras validas.
- 24 palabras validas.
- checksum invalido falla.
- derivacion testnet/mainnet con fixtures.
- parse PSBT invalido falla con error tipado.

#### `lib/core/crypto/transaction_analyzer.dart`

Responsabilidad actual:

- Validar formato base64 y parsear PSBT de forma superficial.
- Devuelve datos mock.

Accion:

- Reescritura completa.
- Debe producir `PsbtReview` con:
  - `network`.
  - `inputs`.
  - `outputs`.
  - `externalOutputs`.
  - `changeOutputs`.
  - `fee`.
  - `feeRate` si posible.
  - `warnings`.
  - `canSign`.
- Si no puede distinguir change, mostrar warning y requerir confirmacion reforzada.

Tests:

- PSBT invalido.
- PSBT valido con output externo.
- PSBT con fee anomala.
- PSBT de red incompatible.

### 4.3 Providers

#### `lib/core/providers/wallet_provider.dart`

Responsabilidad actual:

- Carga seed persistida.
- Fija testnet.
- Deriva descriptor.
- Extrae fingerprint.

Problemas:

- Testnet hardcoded.
- No deriva address.
- `fingerprint` se usa indebidamente como address.

Accion:

- Crear `WalletState` real:
  - `network`.
  - `accountDescriptor`.
  - `fingerprint`.
  - `receiveAddress`.
  - `receivePath`.
  - `accountXpub` si procede.
- Derivar address real desde BDK.

Tests:

- Seed conocida -> direccion esperada.
- Sin seed -> null.
- Network config cambia prefix.

#### `lib/core/providers/seed_provider.dart`

Responsabilidad actual:

- Genera seed, setSeed, expone words, persiste y wipea.

Problemas:

- No guarda metadata.
- `words` depende del estado en memoria.
- Recovery persiste seed sin version/modelo.

Accion:

- Crear `VaultSeedMaterial` o `WalletSecret`.
- Persistir:
  - mnemonic cifrada.
  - mnemonic length.
  - creation date.
  - network.
  - derivation policy version.

Tests:

- Persist/load.
- wipe.
- 12/24.

#### `lib/core/providers/auth_provider.dart`

Responsabilidad actual:

- Estado auth y transiciones del vault.

Problemas:

- `markRecoveryComplete()` pone `uninitialized` tras recovery; flujo puede ser confuso.
- `setupRecoveredVault` existe pero recovery no lo usa de forma evidente.

Accion:

- Redisenar estados:
  - `noVault`.
  - `pinSetupRequired`.
  - `seedBackupRequired`.
  - `locked`.
  - `unlocked`.
  - `biometricSetupRequired`.
  - `recovering`.
- El recovery debe crear vault completo: seed + PIN + metadata.

Tests:

- State machine completa.

#### `lib/core/providers/biometrics_provider.dart`

Responsabilidad actual:

- Lee/escribe flags de biometria.

Accion:

- Convertir a repository/service con keys constantes.
- No decidir seguridad aqui; solo configuracion.

#### `lib/core/providers/history_provider.dart`

Responsabilidad actual:

- JSON de historial en secure storage.

Accion:

- Guardar solo firmas reales.
- Tipar records.
- Considerar persistencia separada no secreta para historial si no contiene secretos.

#### `lib/core/providers/vault_provider.dart`

Responsabilidad actual:

- Determina si existe vault por existencia de hash PIN.

Problema:

- PIN hash no garantiza seed persistida.

Accion:

- Vault existe si hay manifiesto de vault valido y seed material.
- Crear `VaultManifest`.

### 4.4 Seguridad

#### `lib/core/security/auth_barrier.dart`

Responsabilidad actual:

- Registro PIN.
- Autenticacion PIN.
- Biometria-only.

Problemas:

- Politica de firma no es dual auth estricta.
- LocalAuthentication instanciado directamente dificulta tests.

Accion:

- Introducir interfaz `BiometricAuthenticator`.
- Introducir `SigningAuthenticator`.
- Separar `unlock` de `authorizeSigning`.

Tests:

- Fake biometric ok/fail.
- PIN fail incrementa rate limit.
- Signing requiere ambos factores.

#### `lib/core/security/rate_limiter.dart`

Responsabilidad actual:

- Contador de fallos, lockout progresivo, max attempts.

Estado:

- Buena base.

Accion:

- Inyectar clock para tests deterministas.
- Tipar resultado.

#### `lib/core/security/secure_enclave.dart`

Responsabilidad actual:

- Wrapper de `FlutterSecureStorage`.

Problema:

- Nombre promete Secure Enclave real, pero no necesariamente usa Secure Enclave/StrongBox con attestation.

Accion:

- Renombrar a `SecureStorage`.
- Crear interfaz futura `HardwareKeyStore`.
- Solo usar "Secure Enclave" cuando haya implementacion nativa real.

#### `lib/core/security/sealed_state.dart`

Responsabilidad actual:

- Cifra valores en memoria con sodium secretBox.

Accion:

- Mantener.
- Evaluar limpieza de bytes serializados.
- Tests de destroy/tamper.

#### `lib/core/security/threat_detector.dart`, `root_detector.dart`, `threat_policy.dart`

Accion:

- Unificar.
- La firma debe consultar threat policy antes de usar seed.

#### `lib/core/security/app_lifecycle_guard.dart`

Responsabilidad actual:

- Blur al background/inactive.
- Logout al volver de paused.
- Timeout por inactividad.

Accion:

- Mantener.
- Tests widget donde sea viable.

### 4.5 Routing

#### `lib/core/router/app_router.dart`

Responsabilidad actual:

- Redirect segun `AuthState` y biometria.

Problemas:

- Estados insuficientemente expresivos.
- Recovery no esta en rutas declaradas aunque existe screen.

Accion:

- Agregar rutas recovery de forma formal.
- Usar state machine nueva.

### 4.6 Pantallas

#### `lib/presentation/screens/onboarding_screen.dart`

Accion:

- Debe permitir:
  - crear wallet nueva.
  - recuperar wallet.
  - elegir red si el producto lo requiere.
  - elegir 12/24 si aplica en creacion.

#### `lib/presentation/screens/pin_setup_screen.dart`

Estado:

- PIN UI funcional con `VaultConfig.pinLength`.

Accion:

- Asegurar que texto dice longitud real.
- Usar flujo comun para setup new/recovery.

#### `lib/presentation/screens/seed_backup_screen.dart`

Problema:

- Genera seed en `initState` siempre.
- Solo 24 palabras.

Accion:

- Recibir `MnemonicStrength`.
- No regenerar seed si vuelve desde verify.
- Tests de 12 y 24.

#### `lib/presentation/screens/seed_verify_screen.dart`

Problemas:

- Verifica solo 4 palabras.
- Opciones se reconstruyen en build con `Random.secure()`, pueden cambiar al rebuild.

Accion:

- Precalcular challenges y opciones una vez.
- Para fuerzas del estado, subir verificacion:
  - minimo 6 posiciones para 12 palabras.
  - minimo 8 posiciones para 24 palabras.
  - opcion "verificacion completa" para maxima seguridad.

#### `lib/presentation/screens/seed_recovery_screen.dart`

Problemas:

- 24 controllers hardcoded.
- Smart paste corta a 24.

Accion:

- Selector 12/24 o autodeteccion.
- Si paste trae 12 palabras, modo 12.
- Si paste trae 24 palabras, modo 24.
- Rechazar longitudes distintas.

#### `lib/presentation/screens/dashboard_screen.dart`

Problemas:

- Path hardcoded.
- Muestra fingerprint y network copy no suficientemente real.

Accion:

- Mostrar network real.
- Mostrar fingerprint como fingerprint, no como direccion.
- Mostrar estado de vault: locked/unlocked/offline.

#### `lib/presentation/screens/receive_screen.dart`

P0:

- Reescribir para direccion real.

#### `lib/presentation/screens/psbt_review_screen.dart`

P0:

- No usar mocks.
- No avanzar si firma falla.
- Mostrar outputs reales.

#### `lib/presentation/screens/settings_screen.dart`

Accion:

- Agregar red, seed policy, attestation status si existe.
- No permitir cambiar red de wallet existente sin crear wallet nueva.

#### `lib/presentation/screens/biometric_optin_screen.dart`

Accion:

- Texto debe explicar si biometria sirve para unlock o firma.

#### `lib/presentation/screens/about_screen.dart`

Accion:

- Limpiar promesas no implementadas.
- Incluir build hash/version futura.

### 4.7 Widgets

#### `auth_challenge_sheet.dart`

P0:

- Rehacer como challenge dual real para firma.

#### `psbt_scanner_view.dart`

Accion:

- Preparar para UR2 fragmentado.
- Hoy solo captura un QR raw.

#### `signed_qr_visualizer.dart`

Accion:

- Debe soportar payload firmado real y UR2 fragmentado.
- No decir "signed" si no hay firma verificada.

#### `slide_to_sign.dart`

Accion:

- Correcto como interaccion, pero debe estar habilitado solo si review es verificable.

#### Widgets visuales restantes

- `coldbit_action_button.dart`
- `coldbit_drawer.dart`
- `liquid_glass_card.dart`
- `status_pill.dart`

Accion:

- Mantener KISS.
- No meter logica de negocio.

## 5. Protocolo de Trabajo por Tarea

Cada tarea debe seguir este orden exacto:

1. Crear rama desde `develop` actualizada.
2. Leer ficheros del scope con `sed -n`, `rg` y tests existentes.
3. Escribir o actualizar tests antes o junto al cambio.
4. Implementar cambio minimo.
5. Ejecutar formato.
6. Ejecutar analisis.
7. Ejecutar tests con cobertura.
8. Revisar `git diff`.
9. Commit pequeno.
10. Push de la rama.
11. Abrir PR o dejar lista para revision.

Comandos base:

```bash
git checkout develop
git pull --ff-only origin develop
git checkout -b feature/xx-nombre-corto

dart format .
flutter analyze
flutter test --coverage

git status --short
git diff --stat
git diff
git add <files>
git commit -m "feat(scope): mensaje claro"
git push -u origin feature/xx-nombre-corto
```

Nota: Flutter no tiene un comando oficial universal llamado `flutter lint`; en este proyecto el lint se ejecuta mediante `flutter analyze` usando `flutter_lints` y `analysis_options.yaml`.

## 6. Definicion de Cobertura

Regla:

- No bajar cobertura.
- Cada cambio funcional debe agregar tests.
- Cada bug P0 debe tener test que falla antes y pasa despues.

Metas:

| Fase | Cobertura minima objetivo |
| --- | --- |
| Fase 0 Limpieza | baseline medida y documentada |
| Fase 1 Wallet real | +10% sobre baseline |
| Fase 2 PSBT real | +20% sobre baseline |
| Fase 3 Seguridad | +30% sobre baseline |
| Fase 4 UX productiva | cobertura de flujos criticos con widget tests |

Comando:

```bash
flutter test --coverage
```

Reporte local opcional:

```bash
genhtml coverage/lcov.info -o coverage/html
```

Si `genhtml` no esta disponible, no bloquear tarea; bloquear solo si `flutter test --coverage` falla.

## 7. Roadmap Productivo por Fases

### Fase 0 - Higiene, verdad y baseline

Objetivo:

- Dejar el repo en estado medible.
- Eliminar lints actuales.
- Documentar baseline de cobertura.
- Alinear README con realidad temporal sin eliminar vision.

Rama:

```bash
feature/00-quality-baseline
```

Tareas:

#### 0.1 Corregir `flutter analyze`

Scope:

- `lib/core/crypto/wallet_engine.dart`
- `lib/presentation/screens/seed_recovery_screen.dart`
- `test/presentation/screens/seed_recovery_test.dart`

Implementacion:

- Reemplazar import interno BIP39 por alternativa segura.
- Si no hay API publica, crear `lib/core/crypto/bip39_english_wordlist.dart` con fuente fija y checksum documentado.
- Corregir underscores/imports/order.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
fix(lint): restore clean static analysis baseline
```

#### 0.2 Crear baseline de cobertura

Scope:

- `coverage/lcov.info` no necesariamente versionado.
- Documento de baseline en `docs/QUALITY_BASELINE.md`.

Implementacion:

- Ejecutar coverage.
- Registrar porcentaje si herramienta disponible.

Tests:

```bash
flutter test --coverage
flutter analyze
```

Commit:

```text
docs(quality): record initial coverage baseline
```

#### 0.3 Corregir README para no prometer features no reales

Scope:

- `README.md`
- `DESCRIPTION.md`
- `REQUIREMENTS.md`

Implementacion:

- Separar "Implemented", "In progress", "Planned".
- Marcar UR2, BIP86, StrongBox attestation, network broadcast como planned si no existen.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
docs(product): align public claims with implemented wallet capabilities
```

Push:

```bash
git push -u origin feature/00-quality-baseline
```

### Fase 1 - Seed real 12/24 y vault manifest

Objetivo:

- Permitir seleccion real de 12 o 24 palabras.
- Persistir metadata minima de wallet.
- Evitar hardcodes.

Rama:

```bash
feature/01-mnemonic-policy
```

#### 1.1 Crear modelo `MnemonicStrength`

Ficheros esperados:

- `lib/core/crypto/mnemonic_strength.dart`
- `test/core/crypto/mnemonic_strength_test.dart`

Reglas:

- `words12 -> entropy 128`.
- `words24 -> entropy 256`.
- No aceptar 15/18/21 en MVP salvo decision explicita.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(seed): add explicit mnemonic strength policy
```

#### 1.2 Actualizar `WalletEngine.generateMnemonic`

Ficheros:

- `lib/core/crypto/wallet_engine.dart`
- `test/core/crypto/wallet_engine_test.dart`

Reglas:

- Metodo recibe strength.
- Tests validan cantidad de palabras y checksum.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(seed): generate 12 and 24 word mnemonics
```

#### 1.3 Crear `VaultManifest`

Ficheros:

- `lib/core/model/vault_manifest.dart` o `lib/core/vault/vault_manifest.dart`
- `lib/core/providers/vault_provider.dart`
- `lib/core/providers/seed_provider.dart`

Contenido minimo:

- schema version.
- network.
- mnemonic word count.
- derivation standard.
- createdAt.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(vault): persist wallet manifest metadata
```

#### 1.4 UI de seleccion 12/24

Ficheros:

- `onboarding_screen.dart` o nueva pantalla dedicada.
- `seed_backup_screen.dart`.
- `seed_recovery_screen.dart`.
- ARB EN/ES.

Reglas:

- Crear wallet: usuario elige 12 o 24.
- Recovery: autodetectar paste de 12/24 y permitir selector manual.
- Textos no deben decir siempre 24.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(onboarding): support 12 and 24 word recovery phrases
```

### Fase 2 - Direcciones reales y red coherente

Objetivo:

- Receive debe mostrar direccion real derivada.
- Red y path deben ser coherentes.

Rama:

```bash
feature/02-real-receive-address
```

#### 2.1 Crear config de red

Ficheros:

- `lib/core/wallet/wallet_network.dart`
- `lib/core/providers/wallet_provider.dart`

Reglas:

- MVP puede ser testnet-only si se declara.
- Si hay mainnet, debe tener seleccion consciente y warning.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(wallet): add explicit wallet network configuration
```

#### 2.2 Derivar receive address real

Ficheros:

- `wallet_engine.dart`
- `wallet_provider.dart`
- `receive_screen.dart`
- tests crypto/provider.

Reglas:

- No usar fingerprint como address.
- Address debe venir de descriptor/wallet.
- Mostrar path y network.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(receive): derive real bitcoin receive address
```

#### 2.3 Tests de fixture con mnemonic conocida

Ficheros:

- `test/core/crypto/wallet_engine_test.dart`
- fixture si hace falta.

Reglas:

- Seed conocida -> address esperada.
- Si BDK FFI impide CI, aislar con wrapper y testear con fake + integration skip justificado.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
test(wallet): cover deterministic receive address derivation
```

### Fase 3 - PSBT review real y firma fail-closed

Objetivo:

- Ninguna firma sin resumen real.
- Ningun QR firmado sin firma real.

Rama:

```bash
feature/03-real-psbt-review
```

#### 3.1 Crear modelos PSBT tipados

Ficheros:

- `lib/core/crypto/psbt_review.dart`
- `lib/core/crypto/transaction_analyzer.dart`
- tests.

Modelo minimo:

- txid/psbt id real si disponible.
- inputs.
- outputs.
- amount outgoing.
- fee.
- warnings.
- signability.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(psbt): introduce typed transaction review model
```

#### 3.2 Eliminar mocks

Ficheros:

- `transaction_analyzer.dart`
- `psbt_review_screen.dart`

Reglas:

- Si no se puede parsear amount/fee, `canSign=false`.
- UI muestra error especifico.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
fix(psbt): remove mocked transaction amounts from review
```

#### 3.3 Firma fail-closed

Ficheros:

- `psbt_review_screen.dart`
- `wallet_engine.dart`
- widget tests.

Reglas:

- Error de firma no navega a signed QR.
- No registra historial.
- Muestra razon.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
fix(signing): fail closed when psbt signing fails
```

#### 3.4 Fixtures PSBT reales

Ficheros:

- `test/fixtures/psbt/*.txt`
- tests analyzer/signing.

Reglas:

- Fixture valido.
- Fixture corrupto.
- Fixture red incompatible.
- Fixture fee alta.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
test(psbt): add real psbt review fixtures
```

### Fase 4 - Autenticacion de firma realmente dual

Objetivo:

- Firma requiere PIN + biometria si la politica productiva lo exige.

Rama:

```bash
feature/04-dual-signing-auth
```

#### 4.1 Separar unlock de signing auth

Ficheros:

- `auth_barrier.dart`
- `auth_provider.dart`
- `auth_challenge_sheet.dart`

Reglas:

- Unlock puede tener politica configurable.
- Signing debe tener politica estricta.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(auth): separate unlock and signing authorization policies
```

#### 4.2 Inyectar biometria para tests

Ficheros:

- nuevo adapter `biometric_authenticator.dart`.
- tests security.

Reglas:

- No instanciar `LocalAuthentication` directamente en logica no testeable.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
test(auth): add deterministic biometric authorization coverage
```

#### 4.3 UI de challenge dual

Ficheros:

- `auth_challenge_sheet.dart`
- ARB.

Reglas:

- Mostrar dos estados: PIN validado, biometria validada.
- Solo cerrar true cuando ambos pasan.

Tests:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commit:

```text
feat(signing): require pin and biometric approval before signing
```

### Fase 5 - Threat policy productiva

Objetivo:

- Dispositivo comprometido bloquea firma segun policy.

Rama:

```bash
feature/05-threat-policy-enforcement
```

Tareas:

- Unificar `ThreatDetector` y `RootDetector`.
- Crear `ThreatAssessment`.
- Aplicar antes de firma.
- Tests con fake compromised/not compromised.

Comandos por commit:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commits:

```text
refactor(security): unify device threat assessment
feat(signing): block signing on compromised device policy
test(security): cover threat policy signing gates
```

### Fase 6 - UR2 real y QR fragmentado

Objetivo:

- Import/export air-gapped robusto para PSBT grandes.

Rama:

```bash
feature/06-ur2-airgap-transport
```

Tareas:

- Evaluar libreria UR2 mantenida o implementar modulo pequeno con fixtures.
- Crear `UrTransportService`.
- Scanner acumula fragmentos.
- Signed QR visualizer exporta fragmentos animados.

Comandos por commit:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commits:

```text
feat(ur): add ur2 transport service
feat(scanner): assemble animated ur2 qr fragments
feat(export): render signed psbt as ur2 qr sequence
test(ur): cover ur2 encode decode fixtures
```

### Fase 7 - Secure storage honesto y hardware keystore real

Objetivo:

- No llamar Secure Enclave a lo que no lo es.
- Preparar plugin nativo real si el producto lo exige.

Rama:

```bash
feature/07-hardware-keystore-contract
```

Tareas:

- Renombrar wrapper a `SecureStorage`.
- Crear interfaz `HardwareKeyStore`.
- Crear capability screen: hardware backed yes/no/unknown.
- Si se implementa nativo:
  - Android StrongBox/Keystore.
  - iOS Secure Enclave/Keychain.
  - Attestation/export metadata.

Comandos por commit:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commits:

```text
refactor(storage): rename secure storage wrapper honestly
feat(security): add hardware keystore capability contract
feat(settings): display secure storage capability status
```

### Fase 8 - Limpieza nativa y build reproducible

Objetivo:

- Quitar duplicados.
- Asegurar build Android/iOS.

Rama:

```bash
feature/08-native-project-cleanup
```

Tareas:

- Confirmar `android/android` e `ios/ios`.
- Eliminar si son duplicados.
- Ejecutar:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test --coverage
flutter build apk --debug
```

Para iOS, en macOS con Xcode:

```bash
flutter build ios --debug --no-codesign
```

Commits:

```text
chore(native): remove duplicated flutter platform scaffolds
chore(build): verify debug platform builds
```

### Fase 9 - Documentacion productiva y release gate

Objetivo:

- README refleja realidad productiva.
- Checklist de release.

Rama:

```bash
feature/09-production-release-gate
```

Tareas:

- Crear `docs/SECURITY_MODEL.md`.
- Crear `docs/RELEASE_CHECKLIST.md`.
- Crear `docs/THREAT_MODEL.md`.
- Actualizar README.

Comandos:

```bash
dart format .
flutter analyze
flutter test --coverage
```

Commits:

```text
docs(security): define production threat model
docs(release): add strict release checklist
docs(readme): document real implemented capabilities
```

## 8. Commits Baby Steps Recomendados

Orden estricto:

1. `fix(lint): restore clean static analysis baseline`
2. `docs(quality): record initial coverage baseline`
3. `docs(product): align public claims with implemented wallet capabilities`
4. `feat(seed): add explicit mnemonic strength policy`
5. `feat(seed): generate 12 and 24 word mnemonics`
6. `feat(vault): persist wallet manifest metadata`
7. `feat(onboarding): support 12 and 24 word recovery phrases`
8. `feat(wallet): add explicit wallet network configuration`
9. `feat(receive): derive real bitcoin receive address`
10. `test(wallet): cover deterministic receive address derivation`
11. `feat(psbt): introduce typed transaction review model`
12. `fix(psbt): remove mocked transaction amounts from review`
13. `fix(signing): fail closed when psbt signing fails`
14. `test(psbt): add real psbt review fixtures`
15. `feat(auth): separate unlock and signing authorization policies`
16. `test(auth): add deterministic biometric authorization coverage`
17. `feat(signing): require pin and biometric approval before signing`
18. `refactor(security): unify device threat assessment`
19. `feat(signing): block signing on compromised device policy`
20. `test(security): cover threat policy signing gates`
21. `feat(ur): add ur2 transport service`
22. `feat(scanner): assemble animated ur2 qr fragments`
23. `feat(export): render signed psbt as ur2 qr sequence`
24. `test(ur): cover ur2 encode decode fixtures`
25. `refactor(storage): rename secure storage wrapper honestly`
26. `feat(security): add hardware keystore capability contract`
27. `feat(settings): display secure storage capability status`
28. `chore(native): remove duplicated flutter platform scaffolds`
29. `docs(security): define production threat model`
30. `docs(release): add strict release checklist`

## 9. Orden de Lectura para Cualquier Ingeniero

No empezar por UI. Leer en este orden:

1. `README.md`, `DESCRIPTION.md`, `REQUIREMENTS.md`.
2. `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`.
3. `lib/main.dart`.
4. `lib/core/router/app_router.dart`.
5. `lib/core/providers/auth_provider.dart`.
6. `lib/core/providers/vault_provider.dart`.
7. `lib/core/providers/seed_provider.dart`.
8. `lib/core/providers/wallet_provider.dart`.
9. `lib/core/crypto/wallet_engine.dart`.
10. `lib/core/crypto/transaction_analyzer.dart`.
11. `lib/core/security/*`.
12. Pantallas de seed.
13. Pantallas Receive/PSBT.
14. Widgets shared.
15. Tests.

Comandos de lectura:

```bash
rg -n "class|enum|Provider|TODO|FIXME|mock|placeholder|testnet|fingerprint|feeBtc|totalAmountBtc" lib test
sed -n '1,260p' lib/core/crypto/wallet_engine.dart
sed -n '1,260p' lib/core/crypto/transaction_analyzer.dart
sed -n '1,260p' lib/core/providers/wallet_provider.dart
sed -n '1,260p' lib/presentation/screens/receive_screen.dart
sed -n '1,340p' lib/presentation/screens/psbt_review_screen.dart
```

## 10. Que No Hacer

- No hacer refactor grande sin tests.
- No cambiar UI y crypto en el mismo commit si no es imprescindible.
- No introducir librerias crypto sin fixtures.
- No ocultar errores de firma.
- No mostrar datos financieros no verificados.
- No llamar direccion a un fingerprint.
- No llamar Secure Enclave a storage generico.
- No prometer UR2 si solo se escanea un QR raw.
- No mezclar limpieza de carpetas nativas con cambios funcionales.
- No hacer push directo a `develop`.
- No hacer commits gigantes.
- No aumentar cobertura con tests superficiales que solo verifican widgets vacios.

## 11. Criterios de Produccion

La app no es productiva hasta que todo esto sea cierto:

1. `flutter analyze` pasa con cero issues.
2. `flutter test --coverage` pasa.
3. Receive muestra direccion Bitcoin real.
4. PSBT review muestra outputs/fee reales o bloquea firma.
5. Signing falla cerrado.
6. Seed 12/24 esta implementado o README dice claramente que solo hay 24.
7. Signing auth coincide con README.
8. Device compromised bloquea firma si policy lo exige.
9. README no contiene claims falsos.
10. Hay fixtures PSBT reales.
11. Hay tests de derivacion determinista.
12. Hay release checklist.
13. No hay carpetas nativas duplicadas sin justificacion.
14. No hay codigo mock en rutas productivas.

## 12. Gate de PR

Cada PR debe incluir:

```text
Scope:
- ...

Risk:
- Low/Medium/High

Security impact:
- ...

Tests:
- dart format .
- flutter analyze
- flutter test --coverage

Coverage:
- Before:
- After:

Manual verification:
- ...

Rollback:
- ...
```

No aprobar PR si:

- Hay warnings nuevos en `flutter analyze`.
- Baja cobertura sin razon escrita.
- Afecta firma/seed/direccion sin tests.
- Cambia promesas de README sin implementacion.
- Mete codigo mock en flujo productivo.

## 13. Primer Sprint Recomendado

Duracion sugerida: 3 a 5 dias efectivos.

Objetivo:

- Sacar de la zona peligrosa las mentiras funcionales criticas.

Orden:

1. Fase 0 completa.
2. P0-001 Receive real.
3. P0-003 firma fail-closed.
4. P0-002 eliminar mocks de review o bloquear firma hasta parser real.

Ramas:

```bash
feature/00-quality-baseline
feature/02-real-receive-address
feature/03-real-psbt-review
```

No empezar UR2, Taproot ni hardware attestation antes de cerrar estos P0.

## 14. Veredicto

ColdBit Wallet tiene una base seria de app, pero hoy no debe considerarse productiva para fondos reales ni uso institucional.

La ruta a produccion no pasa por mas UI premium. Pasa por verdad criptografica:

- direcciones reales,
- PSBT real,
- firma real,
- fallos cerrados,
- autenticacion coherente,
- almacenamiento nombrado con honestidad,
- tests que rompan si se vuelve a introducir demo-code.

Este documento es el contrato de ejecucion. Si una tarea no mejora una de esas garantias, debe esperar.
