import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../db/database.dart';
import '../../domain/logic/remaining_life.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'pitstop_maintenance';
  static const _channelName = '정비 알림';

  /// 딥링크용 — MainShell 초기화 시 vehicleId 저장
  static int? currentVehicleId;

  /// 알림 탭 콜백 (main.dart에서 등록)
  static void Function(int specId)? onTapped;

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final specId = int.tryParse(details.payload ?? '');
        if (specId != null) onTapped?.call(specId);
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
  /// - warn / overdue 항목  : 내일 오전 9시 알림 (ID = specId)
  /// - 시간 기준 ok 항목    : D-30, D-7 미래 알림 (ID = specId*100+30 / +7)
  /// - ok / unknown 항목   : 기존 알림 취소
  static Future<void> scheduleAll(
      List<({ItemSpec spec, RemainingLifeResult result})> entries) async {
    for (final entry in entries) {
      final spec = entry.spec;
      final result = entry.result;

      if (result.status == ItemStatus.warn ||
          result.status == ItemStatus.overdue) {
        // 내일 오전 9시 경고 알림
        final body = result.status == ItemStatus.overdue
            ? '교체 주기를 초과했습니다. 빠른 교체를 권장합니다.'
            : '교체 시기가 다가오고 있습니다.';
        await _schedule(
          id: spec.id,
          title: spec.name,
          body: body,
          at: _nextMorning(),
          payload: '${spec.id}',
        );
        // 시간 기준 D-30 / D-7 알림은 이미 지났으므로 취소
        await _plugin.cancel(spec.id * 100 + 30);
        await _plugin.cancel(spec.id * 100 + 7);
      } else if (result.status == ItemStatus.ok &&
          spec.lastReplacedDate != null &&
          spec.intervalMonths != null) {
        // ok 이지만 미래 시점에 교체 예정 → D-30 / D-7 선제 알림
        await _plugin.cancel(spec.id); // 경고 알림 제거
        final dueDate = spec.lastReplacedDate!
            .add(Duration(days: (spec.intervalMonths! * 30.4).round()));
        final d30 = dueDate.subtract(const Duration(days: 30));
        final d7 = dueDate.subtract(const Duration(days: 7));
        final now = DateTime.now();

        if (d30.isAfter(now)) {
          await _schedule(
            id: spec.id * 100 + 30,
            title: spec.name,
            body: '30일 후 교체 시기가 도래합니다.',
            at: _toSeoul(d30.copyWith(hour: 9, minute: 0, second: 0)),
            payload: '${spec.id}',
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
            payload: '${spec.id}',
          );
        } else {
          await _plugin.cancel(spec.id * 100 + 7);
        }
      } else {
        // unknown 또는 조건 없음 → 알림 전부 취소
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
