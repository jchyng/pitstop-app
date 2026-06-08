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
}
