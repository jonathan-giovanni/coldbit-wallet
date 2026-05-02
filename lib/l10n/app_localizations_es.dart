// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Bóveda ColdBit';

  @override
  String get onboardingTitle => 'Seguridad Absoluta';

  @override
  String get onboardingSlide1Title => 'Aislamiento Total';

  @override
  String get onboardingSlide1Desc =>
      'Tus llaves privadas nunca tocan la internet. Firma de PSBTs alejada de cualquier red.';

  @override
  String get onboardingSlide2Title => 'Privacidad Extrema';

  @override
  String get onboardingSlide2Desc =>
      'Sin analíticas. Sin rastreo. Sin servidores externos. Tus datos son solo tuyos.';

  @override
  String get onboardingSlide3Title => 'Blindaje Hardware';

  @override
  String get onboardingSlide3Desc =>
      'Protegido por Secure Enclave y patrones de cifrado de grado militar.';

  @override
  String get onboardingSubtitle =>
      'Tus llaves privadas nunca tocan internet. Firma pura de PSBT desconectada de la red.';

  @override
  String get onboardingCreateBtn => 'Crear Bóveda de Cero';

  @override
  String get onboardingCreate24Btn => 'Crear bóveda de 24 palabras';

  @override
  String get onboardingCreate12Btn => 'Crear bóveda de 12 palabras';

  @override
  String get onboardingRecoverBtn => 'Recuperar Semilla Mnemónica';

  @override
  String get introTitle => 'ColdBit Wallet';

  @override
  String get introSubtitle =>
      'Construye una bóveda Bitcoin offline paso a paso: entiende el modelo operativo, elige la longitud de la frase, prepara el respaldo y crea el PIN seguro.';

  @override
  String get introBeginBtn => 'Iniciar onboarding';

  @override
  String get introRecoverBtn => 'Recuperar bóveda existente';

  @override
  String get briefingTitle => 'Briefing operativo';

  @override
  String get briefingSubtitle =>
      'ColdBit está construido para revisión y firma aislada de PSBT. Estas reglas definen cómo debe usarse la bóveda antes de crear cualquier seed.';

  @override
  String get briefingOfflineTitle => 'Mantén el firmante offline';

  @override
  String get briefingOfflineDesc =>
      'Las claves privadas se quedan en este dispositivo. Mueve transacciones sin firmar y firmadas solo por QR o transferencia de archivo.';

  @override
  String get briefingSeedTitle => 'La seed es la bóveda';

  @override
  String get briefingSeedDesc =>
      'Cualquiera con la frase de recuperación puede mover fondos. Escríbela una vez, verifícala y guárdala fuera de sistemas digitales.';

  @override
  String get briefingPsbtTitle => 'Revisa cada PSBT';

  @override
  String get briefingPsbtDesc =>
      'Trata cada transacción importada como hostil hasta comprobar destino, totales y contexto de firma.';

  @override
  String get briefingContinueBtn => 'Continuar';

  @override
  String get vaultModeTitle => 'Elegir modo de bóveda';

  @override
  String get vaultModeSubtitle =>
      'Crea una nueva billetera aislada o restaura una frase conocida. La creación siempre fuerza verificación de respaldo.';

  @override
  String get vaultModeCreateTitle => 'Crear bóveda nueva';

  @override
  String get vaultModeCreateDesc =>
      'Genera localmente una frase BIP39 nueva y protégela con PIN.';

  @override
  String get vaultModeRecoverTitle => 'Recuperar bóveda existente';

  @override
  String get vaultModeRecoverDesc =>
      'Introduce una frase BIP39 válida de 12 o 24 palabras y restaura la bóveda de firma.';

  @override
  String get vaultModeCreateBtn => 'Crear bóveda nueva';

  @override
  String get vaultModeRecoverBtn => 'Recuperar bóveda';

  @override
  String get mnemonicLengthTitle => 'Longitud de frase';

  @override
  String get mnemonicLengthSubtitle =>
      'Elige el tamaño exacto de la seed antes de generarla. ColdBit usará tu selección al crear la frase.';

  @override
  String get mnemonicLength24Title => '24 palabras';

  @override
  String get mnemonicLength24Desc =>
      'Máxima entropía para custodia fría de alto valor y flujos institucionales.';

  @override
  String get mnemonicLength12Title => '12 palabras';

  @override
  String get mnemonicLength12Desc =>
      'Seguridad BIP39 estándar con respaldo y recuperación manual más corta.';

  @override
  String get mnemonicLengthContinueBtn => 'Preparar respaldo';

  @override
  String get backupDisciplineTitle => 'Disciplina de respaldo';

  @override
  String get backupDisciplineSubtitle =>
      'Prepara ahora el entorno físico. La siguiente fase crea la frase de recuperación real.';

  @override
  String get backupDisciplinePaperTitle => 'Usa soporte físico';

  @override
  String get backupDisciplinePaperDesc =>
      'Prepara papel o material metálico antes de revelar la frase.';

  @override
  String get backupDisciplinePrivacyTitle => 'Controla la sala';

  @override
  String get backupDisciplinePrivacyDesc =>
      'Sin cámaras, observadores, pantalla compartida ni soporte remoto durante la creación de la seed.';

  @override
  String get backupDisciplineNoPhotoTitle => 'Nunca la fotografíes';

  @override
  String get backupDisciplineNoPhotoDesc =>
      'No guardes la frase en fotos, gestores de contraseñas, notas en nube, email o chat.';

  @override
  String get backupDisciplineStorageTitle => 'Almacenamiento separado';

  @override
  String get backupDisciplineStorageDesc =>
      'Guarda el respaldo donde sobreviva a la pérdida del dispositivo y no pueda descubrirse casualmente.';

  @override
  String get backupDisciplineContinueBtn => 'Crear PIN seguro';

  @override
  String get pinSetupTitle => 'Acceso Blindado';

  @override
  String get pinSetupCreateMsg => 'Establece tu PIN Seguro';

  @override
  String get pinSetupConfirmMsg => 'Confirmar su PIN Seguro';

  @override
  String get pinSetupHintCreate => 'Elija un código de acceso de 6 dígitos';

  @override
  String get pinSetupHintConfirm =>
      'Repita el código para verificar la precisión';

  @override
  String get pinSetupMismatch => 'Los PIN no coinciden';

  @override
  String get biometricOptinTitle => 'Defensa Biométrica';

  @override
  String get biometricOptinDesc =>
      'Acelera tu acceso atando tu firma biológica. Esta función es totalmente opcional y tu rostro/huella jamás saldrán de este dispositivo.';

  @override
  String get biometricOptinReason => 'Activar biometría para ColdBit Vault';

  @override
  String get biometricOptinSkipBtn => 'Omitir';

  @override
  String get biometricOptinConfirmBtn => 'Confirmar';

  @override
  String get vaultUnlockAccessDenied => 'Acceso Denegado';

  @override
  String get vaultUnlockEnterPin => 'Ingresar PIN';

  @override
  String get vaultUnlockStartSetup => 'Crear o recuperar wallet';

  @override
  String get vaultUnlockStartSetupDesc =>
      'Usa esta opción si quieres iniciar de nuevo el onboarding en este dispositivo.';

  @override
  String vaultUnlockLockedWait(int seconds) {
    return 'BLOQUEADO. Esperar ${seconds}s';
  }

  @override
  String get dashboardVaultLbl => 'Bóveda';

  @override
  String get dashboardStatusLbl => 'Desconectada';

  @override
  String get dashboardMfLbl => 'Huella Maestra';

  @override
  String get dashboardNetworkLbl => 'SegWit Nativo';

  @override
  String get dashboardAuthLog => 'Bitácora';

  @override
  String dashboardSentBtc(String amount) {
    return 'Enviados $amount BTC';
  }

  @override
  String get dashboardReadyTitle => 'Bóveda Alistada';

  @override
  String get dashboardReadyDesc =>
      'Escanea una Transacción de Red (PSBT) para autorizarla en criptografía asimétrica.';

  @override
  String get dashboardScanBtn => 'Escanear Transacción PSBT';

  @override
  String get drawerSettings => 'Ajustes de Bóveda';

  @override
  String get drawerAbout => 'Acerca del Proyecto';

  @override
  String get drawerFallback => 'Respaldado';

  @override
  String get drawerLastUpdate => 'Actualizado';

  @override
  String get settingsTitle => 'Ajustes de Bóveda';

  @override
  String get settingsLanguage => 'Idioma / Language';

  @override
  String get settingsLanguageDesc => 'Español • English';

  @override
  String get settingsCamera => 'Cámara (Escáner QR)';

  @override
  String get settingsCameraDesc =>
      'Requerida para capturar tickets PSBT de la red.';

  @override
  String get settingsPush => 'Notificaciones Push';

  @override
  String get settingsPushDesc =>
      'Monitoreo alerta de hackeos locales o jailbreak';

  @override
  String get settingsBiometrics => 'Autenticación Biométrica';

  @override
  String get settingsBiometricsDesc =>
      'Reemplaza el tecleo recurrente del código cifrado';

  @override
  String get aboutTitle => 'Acerca del Proyecto';

  @override
  String get aboutMissionMd =>
      '# Misión de ColdBit Wallet\n\nEsta aplicación fue forjada con un propósito absoluto: **Asumir que todos los entornos en internet están comprometidos o son inherentemente hostiles**.\n\n## Principios de Diseño\n1. **Air-gapped Puro**: \n   Tu dispositivo no enviará una sola clave privada a la internet abierta. Solo firma de PSBTs.\n2. **Defensa de Capa RAM (MemGuard)**: \n   Las semillas (Seed Phrases) existen en RAM criptográfica sellada temporal. Se pulsa y se quema a discreción.\n\n---\n\n### Componentes de Seguridad Implementados:\n- **libsodium**: Derivación de hashes estilo Argon2id y almacenamiento aislado.\n- **Fail-Close Policy**: Cualquier perturbación (salir de la App, fallo biométrico, jailbreak detectado) colapsa la sesión por protocolo.\n\n*El software es para uso soberano. Verifique el Hash del código y construya usted mismo.*';

  @override
  String get seedBackupTitle => 'Frase de Recuperación';

  @override
  String seedBackupWarning(int count) {
    return 'Escribe estas $count palabras en orden. Es tu ÚNICA forma de recuperar tu billetera. Nunca las compartas. Nunca las guardes digitalmente.';
  }

  @override
  String get seedBackupHiddenTitle => 'Frase Oculta';

  @override
  String get seedBackupHiddenDesc =>
      'Asegúrate de que nadie pueda ver tu pantalla antes de revelar tu frase de recuperación.';

  @override
  String get seedBackupRevealBtn => 'Revelar Frase';

  @override
  String get seedBackupContinueBtn => 'Ya La Escribí';

  @override
  String get seedVerifyTitle => 'Verificar Respaldo';

  @override
  String get seedVerifyDesc =>
      'Selecciona la palabra correcta para cada posición para confirmar que guardaste tu frase de recuperación.';

  @override
  String seedVerifyWordLabel(int number) {
    return 'Palabra #$number';
  }

  @override
  String get seedVerifyFailed => 'Selección incorrecta. Intenta de nuevo.';

  @override
  String get seedVerifyConfirmBtn => 'Confirmar Respaldo';

  @override
  String get receiveTitle => 'Dirección de Recepción';

  @override
  String get receiveDesc =>
      'Comparte esta dirección para recibir Bitcoin. Verifica que coincida con tu dispositivo antes de enviar fondos.';

  @override
  String get receiveError => 'Error al derivar la dirección';

  @override
  String get receiveNoWallet => 'No hay billetera configurada';

  @override
  String get receiveCopied => 'Dirección copiada al portapapeles';

  @override
  String get receiveOfflineNote =>
      'Esta dirección fue derivada offline desde tu semilla. Siempre verifica en tu dispositivo hardware antes de aceptar transacciones grandes.';

  @override
  String get recoverTitle => 'Recuperar Bóveda';

  @override
  String get recoverDesc =>
      'Ingresa tu frase de recuperación para restaurar tu billetera. Cada palabra debe pertenecer a la lista estándar BIP39.';

  @override
  String get recoverWords12 => '12 palabras';

  @override
  String get recoverWords24 => '24 palabras';

  @override
  String get recoverInvalidSeed =>
      'Frase de recuperación inválida. Verifica cada palabra cuidadosamente.';

  @override
  String get recoverError => 'Error en la recuperación. Intenta de nuevo.';

  @override
  String get recoverConfirmBtn => 'Restaurar Bóveda';
}
