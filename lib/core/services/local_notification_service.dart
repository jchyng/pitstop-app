import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../db/database.dart';
import '../../domain/logic/remaining_life.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'pitstop_maintenance';
  static const _channelName = '정비 알림';

  /// 알림 탭 콜백 — payload 형식: "vehicleId:specId"
  static void Function(String payload)? onTapped;

  /// 딥링크 폴백용 (payload 파싱 실패 시)
  static int? currentVehicleId;

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null && payload.isNotEmpty) onTapped?.call(payload);
      },
    );

    // Android 13+ 알림 권한 요청
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// 소모품 상태 목록을 받아 알림을 재스케줄한다.
  ///
  /// - warn / overdue 항목: 내일 오전 9시 경고 알림 (ID = specId)
  /// - ok 항목 (remainingDays 있음): D-30, D-7 선제 알림 (ID = specId*100+30/+7)
  ///   - 시간 기준: lastReplacedDate + intervalMonths 로 고정 due date
  ///   - km 기준 추정: now + remainingDays 로 추정 due date
  /// - unknown 또는 remainingDays 없음: 모든 알림 취소
  static Future<void> scheduleAll(
      List<({ItemSpec spec, RemainingLifeResult result})> entries,
      {required int vehicleId}) async {
    for (final entry in entries) {
      final spec = entry.spec;
      final result = entry.result;
      final payload = '$vehicleId:${spec.id}';

      if (result.status == ItemStatus.warn ||
          result.status == ItemStatus.overdue) {
        final body = result.status == ItemStatus.overdue
            ? '교체 주기를 초과했습니다. 빠른 교체를 권장합니다.'
            : '교체 시기가 다가오고 있습니다.';
        await _schedule(
          id: spec.id,
          title: spec.name,
          body: body,
          at: _nextMorning(),
          payload: payload,
        );
        await _plugin.cancel(spec.id * 100 + 30);
        await _plugin.cancel(spec.id * 100 + 7);
      } else if (result.status == ItemStatus.ok &&
          result.remainingDays != null) {
        await _plugin.cancel(spec.id);

        // 고정 due date (시간 기준) vs 추정 due date (km 기준)
        final DateTime dueDate;
        if (spec.lastReplacedDate != null && spec.intervalMonths != null) {
          dueDate = spec.lastReplacedDate!
              .add(Duration(days: (spec.intervalMonths! * 30.4).round()));
        } else {
          dueDate =
              DateTime.now().add(Duration(days: result.remainingDays!));
        }

        final now = DateTime.now();
        final d30 = dueDate.subtract(const Duration(days: 30));
        final d7 = dueDate.subtract(const Duration(days: 7));

        if (d30.isAfter(now)) {
          await _schedule(
            id: spec.id * 100 + 30,
            title: spec.name,
            body: '30일 후 교체 시기가 도래합니다.',
            at: _toSeoul(d30.copyWith(hour: 9, minute: 0, second: 0)),
            payload: payload,
          );
        } else {
          await _plugin.cancel(spec.id * 100 + 30);
        }

        if (d7.isAfter(now)) {
          await _schedule(
            id: spec.id * 100 + 7,
            title: spec.name,
            body: '7일 후 교체 시기가 도래합니다.',
            at: _toSeoul(d7.copyWith(hour: 9, minute: 0, second: 0)),
            payload: payload,
          );
        } else {
          await _plugin.cancel(spec.id * 100 + 7);
        }
      } else {
        await _plugin.cancel(spec.id);
        await _plugin.cancel(spec.id * 100 + 30);
        await _plugin.cancel(spec.id * 100 + 7);
      }
    }
  }

  static Future<void> cancelAll() => _plugin.cancelAll();

  // ─── 내부 유틸 ─────────────────────────────────────────────

  static Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime at,
    String? payload,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      at,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// 다음 오전 9시 (이미 지났으면 내일)
  static tz.TZDateTime _nextMorning() {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    if (t.isBefore(now)) t = t.add(const Duration(days: 1));
    return t;
  }

  static tz.TZDateTime _toSeoul(DateTime dt) =>
      tz.TZDateTime.from(dt, tz.local);
}
