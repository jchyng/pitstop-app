import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core/db/database.dart';
import 'core/db/catalog_loader.dart';
import 'domain/logic/remaining_life.dart';

part 'providers.g.dart';

typedef ItemStatusEntry = ({ItemSpec spec, RemainingLifeResult result});

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@riverpod
Future<void> appInit(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  await CatalogLoader.seedIfEmpty(db);
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

/// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
@riverpod
Future<List<ItemStatusEntry>> sortedItemStatus(
    Ref ref, int vehicleId) async {
  final db = ref.watch(appDatabaseProvider);

  final vehicle = await (db.select(db.vehicles)
        ..where((v) => v.id.equals(vehicleId)))
      .getSingle();

  final specs = await (db.select(db.itemSpecs)
        ..where((t) => t.vehicleId.equals(vehicleId)))
      .get();

  final today = DateTime.now();
  final entries = specs
      .map((spec) => (
            spec: spec,
            result: calculateRemainingLife(spec, vehicle.currentOdometer, today),
          ))
      .toList();

  // overdue(ratio≈0) → warn → ok → unknown(ratio=null) 순
  entries.sort((a, b) {
    final aRatio = a.result.ratio;
    final bRatio = b.result.ratio;
    if (aRatio == null && bRatio == null) return 0;
    if (aRatio == null) return 1;
    if (bRatio == null) return -1;
    return aRatio.compareTo(bRatio);
  });

  return entries;
}
