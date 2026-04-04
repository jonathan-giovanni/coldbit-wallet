import 'package:sodium_libs/sodium_libs.dart';

class MemGuard {
  static Sodium? _sodium;

  static Future<void> init() async {
    if (_sodium != null) return;
    _sodium = await SodiumInit.init();
  }

  static Sodium get sodium {
    if (_sodium == null) {
      throw StateError('MEMGUARD_NOT_INITIALIZED');
    }
    return _sodium!;
  }
}
