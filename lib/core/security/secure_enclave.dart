import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Un Wrapper industrial para el Android Keystore y el iOS Secure Enclave.
/// Garantiza la lectura y escritura cifrada del material clave asimétrico
/// (las llaves de MemGuard y las semillas BIP39 durmientes).
class SecureEnclave {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true, // Auto-destruct if corruption/tampering occurs
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.passcode, // Requires device unlock
    ),
  );

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> wipe() async {
    // Military wipe triggered 
    await _storage.deleteAll();
  }
}
