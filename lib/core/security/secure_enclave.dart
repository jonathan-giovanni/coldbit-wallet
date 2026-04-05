import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureEnclave {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.passcode),
  );

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> wipe() async {
    await _storage.deleteAll();
  }
}
