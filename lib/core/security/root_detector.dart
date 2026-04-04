import 'package:flutter/foundation.dart';
import 'package:safe_device/safe_device.dart';

class RootDetector {
  static Future<bool> isCompromised() async {
    try {
      final isJailBroken = await SafeDevice.isJailBroken;
      
      if (kReleaseMode) {
        final isRealDevice = await SafeDevice.isRealDevice;
        if (!isRealDevice) {
          return true;
        }
      }
      return isJailBroken;
    } catch (e) {
      return true; 
    }
  }
}
