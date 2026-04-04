import 'package:sodium_libs/sodium_libs.dart';

/// MemGuard acts as the root hardware/memory isolation manager.
class MemGuard {
  static Sodium? _sodium;

  /// Initializes the Sodium native library FFI.
  /// Must be called once during app bootstrap.
  static Future<void> init() async {
    if (_sodium != null) return;
    _sodium = await SodiumInit.init();
  }

  /// Returns the current Sodium instance. Throws if not initialized.
  static Sodium get sodium {
    if (_sodium == null) {
      throw StateError('MemGuard has not been initialized. Call MemGuard.init() first.');
    }
    return _sodium!;
  }
}
