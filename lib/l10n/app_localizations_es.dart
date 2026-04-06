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
  String get onboardingSubtitle =>
      'Tus llaves privadas nunca tocan internet. Firma pura de PSBT desconectada de la red.';

  @override
  String get onboardingCreateBtn => 'Crear Bóveda de Cero';

  @override
  String get onboardingRecoverBtn => 'Recuperar Semilla Mnemónica';

  @override
  String get pinSetupTitle => 'Acceso Blindado';

  @override
  String get pinSetupCreateMsg => 'Establece tu PIN Seguro';

  @override
  String get pinSetupConfirmMsg => 'Confirma tu PIN Seguro';

  @override
  String get pinSetupMismatch => 'Los PINs no coinciden';

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
  String get seedBackupWarning =>
      'Escribe estas 24 palabras en orden. Es tu ÚNICA forma de recuperar tu billetera. Nunca las compartas. Nunca las guardes digitalmente.';

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
}
