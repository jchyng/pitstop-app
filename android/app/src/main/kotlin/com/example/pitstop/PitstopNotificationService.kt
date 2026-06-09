package com.example.pitstop

import android.app.Notification
import android.os.Handler
import android.os.Looper
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import io.flutter.plugin.common.EventChannel

class PitstopNotificationService : NotificationListenerService() {
    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val extras = sbn.notification.extras
        val title = extras.getString(Notification.EXTRA_TITLE) ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""

        val data = mapOf(
            "packageName" to sbn.packageName,
            "title" to title,
            "text" to text,
            "postTime" to sbn.postTime,
        )

        Handler(Looper.getMainLooper()).post {
            eventSink?.success(data)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {}
}
