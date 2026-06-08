import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core/db/database.dart';
import 'core/db/catalog_loader.dart';

part 'providers.g.dart';

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
