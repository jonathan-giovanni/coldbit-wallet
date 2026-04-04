import 'package:flutter/foundation.dart';
import 'package:safe_device/safe_device.dart';

class RootDetector {
  /// Confirma si el dispositivo huésped está comprometido o es inseguro para una Cold Wallet.
  /// Implementa fail-close estricto guiado.
  static Future<bool> isCompromised() async {
    try {
      final isJailBroken = await SafeDevice.isJailBroken;
      
      // Strict Simulator Check:
      // En modo Release (Producción real), los simuladores son categorizados
      // automáticamente como vectores de ataque (Dynamic Analysis Tools).
      // Sólo lo permitimos en Debug para desarrollo interno.
      if (kReleaseMode) {
        final isRealDevice = await SafeDevice.isRealDevice;
        if (!isRealDevice) {
          return true; // Simulator detected in production build!
        }
      }
      
      return isJailBroken;
    } catch (e) {
      // Paradigma militar: Falla cerrada. 
      // Si la llamada nativa de seguridad es interceptada o crashea, el dispositivo es hostil.
      return true; 
    }
  }
}
