import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ThreatDetector {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidConfig = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosConfig = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidConfig, iOS: iosConfig);
    
    await _notificationsPlugin.initialize(settings: settings);
  }

  static Future<bool> isCompromised() async {
    try {
      bool jailbroken = await FlutterJailbreakDetection.jailbroken;
      bool developerMode = await FlutterJailbreakDetection.developerMode;
      
      if (jailbroken || developerMode) {
        await _fireThreatNotification();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _fireThreatNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'threat_alert', 'Security Threats',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.red, 
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    
    await _notificationsPlugin.show(
      id: 999,
      title: 'CRITICAL SECURITY ALERT',
      body: 'Unauthorized OS manipulation (Jailbreak/Root) detected. Memory isolated.',
      notificationDetails: details,
    );
  }
}
