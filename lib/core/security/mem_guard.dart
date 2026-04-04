import 'dart:ffi';
import 'dart:io';
import 'package:sodium_libs/sodium_libs_sumo.dart';
import 'package:sodium/sodium_sumo.dart' as pure_sodium;

class MemGuard {
  static SodiumSumo? _sodium;

  static Future<void> init() async {
    if (_sodium != null) return;
    
    if (Platform.environment.containsKey('FLUTTER_TEST') && Platform.isMacOS) {
      final lib = DynamicLibrary.open('/opt/homebrew/lib/libsodium.dylib');
      _sodium = await pure_sodium.SodiumSumoInit.init(() => lib);
      return;
    }
    
    _sodium = await SodiumSumoInit.init();
  }

  static SodiumSumo get sodium {
    if (_sodium == null) {
      throw StateError('MEMGUARD_NOT_INITIALIZED');
    }
    return _sodium!;
  }
}
