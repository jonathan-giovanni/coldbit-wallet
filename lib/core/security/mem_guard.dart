import 'dart:ffi';
import 'dart:io';

import 'package:sodium/sodium_sumo.dart' as pure_sodium;
import 'package:sodium_libs/sodium_libs_sumo.dart';

class MemGuard {
  static SodiumSumo? _sodium;

  static Future<void> init() async {
    if (_sodium != null) return;

    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      String? libPath;
      if (Platform.isMacOS) {
        libPath = '/opt/homebrew/lib/libsodium.dylib';
      } else if (Platform.isLinux) {
        // Common paths for libsodium on Ubuntu/Debian
        libPath = 'libsodium.so'; 
      }
      
      if (libPath != null) {
        final lib = DynamicLibrary.open(libPath);
        _sodium = await pure_sodium.SodiumSumoInit.init(() => lib);
        return;
      }
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
