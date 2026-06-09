import 'package:flutter/services.dart';

class NotificationService {
  static const _eventChannel =
      EventChannel('com.example.pitstop/notifications');
  static const _methodChannel =
      MethodChannel('com.example.pitstop/notification_permission');

  /// Android NotificationListenerService 에서 오는 알림 원시 스트림.
  static Stream<Map<dynamic, dynamic>> get rawStream =>
      _eventChannel.receiveBroadcastStream().cast<Map<dynamic, dynamic>>();

  static Future<bool> isPermissionGranted() async {
    try {
      return await _methodChannel.invokeMethod<bool>('isPermissionGranted') ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> openPermissionSettings() async {
    try {
      await _methodChannel.invokeMethod('openPermissionSettings');
    } catch (_) {}
  }
}
