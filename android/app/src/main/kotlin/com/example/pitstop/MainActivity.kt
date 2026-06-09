package com.example.pitstop

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        const val NOTIFICATION_EVENT_CHANNEL = "com.example.pitstop/notifications"
        const val PERMISSION_METHOD_CHANNEL = "com.example.pitstop/notification_permission"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 알림 이벤트 스트림
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    PitstopNotificationService.eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    PitstopNotificationService.eventSink = null
                }
            })

        // 권한 확인 / 설정 이동
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSION_METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isPermissionGranted" -> result.success(isNotificationListenerEnabled())
                    "openPermissionSettings" -> {
                        startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun isNotificationListenerEnabled(): Boolean {
        val listeners = Settings.Secure.getString(
            contentResolver, "enabled_notification_listeners"
        )
        return listeners?.contains(packageName) == true
    }
}
