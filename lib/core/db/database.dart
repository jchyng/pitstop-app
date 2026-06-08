import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ─── 테이블 정의 ───────────────────────────────────────────

class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // 별칭 (예: "내 렉스턴")
  TextColumn get model => text()(); // 예: "렉스턴 스포츠 칸 디젤"
  TextColumn get trim => text().nullable()();
  IntColumn get year => integer().nullable()();
  IntColumn get currentOdometer => integer().withDefault(const Constant(0))();
  DateTimeColumn get registeredAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class ItemSpecs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId => integer().references(Vehicles, #id)();
  TextColumn get key => text()(); // 안정적 식별자 (예: "engine-oil")
  TextColumn get name => text()(); // 표시명 (예: "엔진오일")
  TextColumn get category => text()();
  IntColumn get intervalKm => integer().nullable()();
  IntColumn get intervalMonths => integer().nullable()();
  IntColumn get severeIntervalKm => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get behavior => text().nullable()(); // replace_only / inspect_only / both
  IntColumn get lastReplacedOdometer => integer().nullable()();
  DateTimeColumn get lastReplacedDate => dateTime().nullable()();
}

class MaintenanceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId => integer().references(Vehicles, #id)();
  IntColumn get itemSpecId =>
      integer().nullable().references(ItemSpecs, #id)();
  TextColumn get type => text()(); // replace / inspect / refill
  DateTimeColumn get date => dateTime()();
  IntColumn get odometer => integer()();
  TextColumn get place => text().nullable()();
  TextColumn get memo => text().nullable()();
  IntColumn get expenseId =>
      integer().nullable().references(Expenses, #id)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId => integer().references(Vehicles, #id)();
  TextColumn get category => text()(); // fuel / maintenance / insurance_tax / parking_toll / etc
  TextColumn get title => text()();
  TextColumn get place => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get source =>
      text().withDefault(const Constant('manual'))(); // manual / auto
  TextColumn get rawMessage => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ─── 데이터베이스 ───────────────────────────────────────────

@DriftDatabase(tables: [Vehicles, ItemSpecs, MaintenanceRecords, Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pitstop_db');
  }

  // ─── 조회 ─────────────────────────────────────────────────

  Future<ItemSpec?> getItemSpec(int specId) =>
      (select(itemSpecs)..where((s) => s.id.equals(specId))).getSingleOrNull();

  Future<List<MaintenanceRecord>> getMaintenanceRecordsForSpec(int specId) =>
      (select(maintenanceRecords)
            ..where((r) => r.itemSpecId.equals(specId))
            ..orderBy([(r) => OrderingTerm.desc(r.date)]))
          .get();

  // ─── last_replaced 캐시 갱신 ──────────────────────────────

  Future<void> _refreshLastReplaced(int specId) async {
    final latest = await (select(maintenanceRecords)
          ..where((r) =>
              r.itemSpecId.equals(specId) & r.type.equals('replace'))
          ..orderBy([(r) => OrderingTerm.desc(r.date)])
          ..limit(1))
        .getSingleOrNull();

    await (update(itemSpecs)..where((s) => s.id.equals(specId))).write(
      ItemSpecsCompanion(
        lastReplacedOdometer: Value(latest?.odometer),
        lastReplacedDate: Value(latest?.date),
      ),
    );
  }

  // ─── 이력 CRUD ────────────────────────────────────────────

  Future<void> addRecord({
    required int vehicleId,
    required int specId,
    required String specName,
    required String type,
    required DateTime date,
    required int odometer,
    int? amount,
    String? place,
    String? memo,
  }) async {
    await transaction(() async {
      final recId = await into(maintenanceRecords).insert(
        MaintenanceRecordsCompanion.insert(
          vehicleId: vehicleId,
          itemSpecId: Value(specId),
          type: type,
          date: date,
          odometer: odometer,
          place: Value(place),
          memo: Value(memo),
        ),
      );

      if (amount != null && amount > 0) {
        final expId = await into(expenses).insert(
          ExpensesCompanion.insert(
            vehicleId: vehicleId,
            category: 'maintenance',
            title: specName,
            date: date,
            amount: amount,
            place: Value(place),
          ),
        );
        await (update(maintenanceRecords)..where((r) => r.id.equals(recId)))
            .write(MaintenanceRecordsCompanion(expenseId: Value(expId)));
      }

      if (type == 'replace') await _refreshLastReplaced(specId);

      final vehicle =
          await (select(vehicles)..where((v) => v.id.equals(vehicleId)))
              .getSingle();
      if (odometer > vehicle.currentOdometer) {
        await (update(vehicles)..where((v) => v.id.equals(vehicleId)))
            .write(VehiclesCompanion(currentOdometer: Value(odometer)));
      }
    });
  }

  Future<void> updateRecord({
    required MaintenanceRecord existing,
    required String specName,
    required String type,
    required DateTime date,
    required int odometer,
    int? amount,
    String? place,
    String? memo,
  }) async {
    await transaction(() async {
      await (update(maintenanceRecords)
            ..where((r) => r.id.equals(existing.id)))
          .write(MaintenanceRecordsCompanion(
            type: Value(type),
            date: Value(date),
            odometer: Value(odometer),
            place: Value(place),
            memo: Value(memo),
          ));

      final hasAmount = amount != null && amount > 0;
      if (hasAmount && existing.expenseId == null) {
        final expId = await into(expenses).insert(
          ExpensesCompanion.insert(
            vehicleId: existing.vehicleId,
            category: 'maintenance',
            title: specName,
            date: date,
            amount: amount,
            place: Value(place),
          ),
        );
        await (update(maintenanceRecords)
              ..where((r) => r.id.equals(existing.id)))
            .write(MaintenanceRecordsCompanion(expenseId: Value(expId)));
      } else if (hasAmount && existing.expenseId != null) {
        await (update(expenses)
              ..where((e) => e.id.equals(existing.expenseId!)))
            .write(ExpensesCompanion(
              title: Value(specName),
              date: Value(date),
              amount: Value(amount),
              place: Value(place),
            ));
      } else if (!hasAmount && existing.expenseId != null) {
        await (delete(expenses)
              ..where((e) => e.id.equals(existing.expenseId!)))
            .go();
        await (update(maintenanceRecords)
              ..where((r) => r.id.equals(existing.id)))
            .write(const MaintenanceRecordsCompanion(expenseId: Value(null)));
      }

      if (type == 'replace' || existing.type == 'replace') {
        await _refreshLastReplaced(existing.itemSpecId!);
      }

      final vehicle =
          await (select(vehicles)..where((v) => v.id.equals(existing.vehicleId)))
              .getSingle();
      if (odometer > vehicle.currentOdometer) {
        await (update(vehicles)..where((v) => v.id.equals(existing.vehicleId)))
            .write(VehiclesCompanion(currentOdometer: Value(odometer)));
      }
    });
  }

  Future<void> deleteRecord(MaintenanceRecord rec) async {
    await transaction(() async {
      if (rec.expenseId != null) {
        await (delete(expenses)..where((e) => e.id.equals(rec.expenseId!)))
            .go();
      }
      await (delete(maintenanceRecords)..where((r) => r.id.equals(rec.id)))
          .go();
      if (rec.itemSpecId != null) await _refreshLastReplaced(rec.itemSpecId!);
    });
  }
}
