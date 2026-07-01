import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core/db/catalog_loader.dart';
import 'core/db/database.dart';
import 'core/services/local_notification_service.dart';
import 'core/services/notification_service.dart';
import 'core/utils/notification_parser.dart';
import 'domain/logic/remaining_life.dart';

part 'providers.g.dart';

typedef ItemStatusEntry = ({ItemSpec spec, RemainingLifeResult result});

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@riverpod
Future<void> appInit(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final vehicles = await db.select(db.vehicles).get();
  for (final vehicle in vehicles) {
    await CatalogLoader.syncCatalogItems(db, vehicle);
  }
}

@riverpod
Future<List<Vehicle>> vehicles(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.select(db.vehicles).get();
}

@riverpod
Future<List<ItemSpec>> itemSpecs(Ref ref, int vehicleId) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.itemSpecs)
        ..where((t) => t.vehicleId.equals(vehicleId)))
      .get();
}

// ─── 가계부 타입 ───────────────────────────────────────────────

typedef RecordWithSpec = ({MaintenanceRecord record, ItemSpec? spec});

typedef ExpenseSummaryData = ({
  int total,
  int prevTotal,
  Map<String, int> byCategory,
  int? monthlyKm,
});

@riverpod
Future<List<Expense>> monthlyExpenses(
    Ref ref, int vehicleId, int year, int month) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getMonthExpenses(vehicleId, year, month);
}

@riverpod
Future<ExpenseSummaryData> monthlySummary(
    Ref ref, int vehicleId, int year, int month) async {
  final db = ref.watch(appDatabaseProvider);

  final current = await db.getMonthExpenses(vehicleId, year, month);

  final prevMonth = month == 1 ? 12 : month - 1;
  final prevYear = month == 1 ? year - 1 : year;
  final prev = await db.getMonthExpenses(vehicleId, prevYear, prevMonth);

  final total = current.fold(0, (s, e) => s + e.amount);
  final prevTotal = prev.fold(0, (s, e) => s + e.amount);

  final byCategory = <String, int>{};
  for (final e in current) {
    byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
  }

  final monthlyKm = await db.getMonthKmDelta(vehicleId, year, month);

  return (
    total: total,
    prevTotal: prevTotal,
    byCategory: byCategory,
    monthlyKm: monthlyKm,
  );
}

@riverpod
Future<List<RecordWithSpec>> allMaintenanceRecords(
    Ref ref, int vehicleId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getAllRecordsWithSpec(vehicleId);
}

@riverpod
Future<ItemSpec?> itemSpec(Ref ref, int specId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getItemSpec(specId);
}

@riverpod
Future<List<MaintenanceRecord>> maintenanceRecords(Ref ref, int specId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getMaintenanceRecordsForSpec(specId);
}

/// 소모품 남은 수명 계산 결과.
/// 정렬: overdue → warn → ok → unknown, 같은 상태 내에서는 ratio 오름차순(더 임박한 것 위),
/// unknown 내에서는 intervalKm 오름차순.
@riverpod
Future<List<ItemStatusEntry>> sortedItemStatus(
    Ref ref, int vehicleId) async {
  final db = ref.watch(appDatabaseProvider);

  final vehicle = await (db.select(db.vehicles)
        ..where((v) => v.id.equals(vehicleId)))
      .getSingle();

  final specs = await db.getVisibleItemSpecs(vehicleId);

  final today = DateTime.now();
  final entries = specs
      .map((spec) => (
            spec: spec,
            result: calculateRemainingLife(spec, vehicle.currentOdometer, today),
          ))
      .toList();

  int statusOrder(ItemStatus s) => switch (s) {
        ItemStatus.overdue => 0,
        ItemStatus.warn => 1,
        ItemStatus.ok => 2,
        ItemStatus.unknown => 3,
      };

  const inf = 0x7fffffff;
  entries.sort((a, b) {
    final sa = statusOrder(a.result.status);
    final sb = statusOrder(b.result.status);
    if (sa != sb) return sa.compareTo(sb);

    if (a.result.status != ItemStatus.unknown) {
      final ra = a.result.ratio ?? 1.0;
      final rb = b.result.ratio ?? 1.0;
      if (ra != rb) return ra.compareTo(rb);
    }

    final aKm = a.spec.intervalKm ?? inf;
    final bKm = b.spec.intervalKm ?? inf;
    if (aKm != bKm) return aKm.compareTo(bKm);
    final aM = a.spec.intervalMonths ?? inf;
    final bM = b.spec.intervalMonths ?? inf;
    return aM.compareTo(bM);
  });

  return entries;
}

/// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
@riverpod
Future<List<ItemSpec>> allItemSpecs(Ref ref, int vehicleId) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getAllItemSpecs(vehicleId);
}

// ─── 로컬 알림 스케줄 ─────────────────────────────────────────

/// vehicles + sortedItemStatus 를 watch해 소모품 상태 변경 시 자동으로
/// 로컬 알림을 재스케줄한다. MainShell에서 ref.watch만 하면 된다.
@riverpod
Future<void> scheduleNotifications(Ref ref) async {
  final vehicles = await ref.watch(vehiclesProvider.future);
  if (vehicles.isEmpty) return;
  LocalNotificationService.currentVehicleId = vehicles.first.id;
  for (final vehicle in vehicles) {
    final entries =
        await ref.watch(sortedItemStatusProvider(vehicle.id).future);
    await LocalNotificationService.scheduleAll(entries,
        vehicleId: vehicle.id);
  }
}

// ─── 알림 파싱 ────────────────────────────────────────────────

/// Android NotificationListenerService 원시 스트림 → 주유비만 필터링.
@Riverpod(keepAlive: true)
Stream<ParsedFuelExpense> fuelNotificationStream(Ref ref) {
  return NotificationService.rawStream
      .map((n) => NotificationParser.tryParse(n))
      .where((e) => e != null)
      .cast<ParsedFuelExpense>();
}

/// 알림 접근 권한 여부 (앱 포그라운드 진입 시 확인).
@riverpod
Future<bool> notificationPermission(Ref ref) async {
  return NotificationService.isPermissionGranted();
}
