import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'database.dart';

class CatalogInfo {
  final String assetPath;
  final String nameKo;
  const CatalogInfo({required this.assetPath, required this.nameKo});
}

class CatalogLoader {
  /// assets/catalog/*.json 목록을 AssetManifest에서 읽어 반환.
  static Future<List<CatalogInfo>> listCatalogs() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith('assets/catalog/') && p.endsWith('.json'))
        .toList()
      ..sort();

    final result = <CatalogInfo>[];
    for (final path in paths) {
      try {
        final raw = await rootBundle.loadString(path);
        final json = jsonDecode(raw) as Map<String, dynamic>;
        result.add(CatalogInfo(
          assetPath: path,
          nameKo: json['name_ko'] as String,
        ));
      } catch (_) {
        // 파싱 실패 파일 건너뜀
      }
    }
    return result;
  }

  /// 차량 model명과 일치하는 카탈로그 JSON을 찾아 DB와 동기화.
  /// - JSON에 없는 카탈로그 항목 → isHidden = true (이력 보존)
  /// - JSON에 새로 생긴 항목 → DB에 추가
  /// - 커스텀 항목(key가 'custom_'으로 시작) → 건드리지 않음
  static Future<void> syncCatalogItems(
    AppDatabase db,
    Vehicle vehicle,
  ) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest
        .listAssets()
        .where((p) => p.startsWith('assets/catalog/') && p.endsWith('.json'))
        .toList();

    Map<String, dynamic>? catalogJson;
    for (final path in paths) {
      try {
        final raw = await rootBundle.loadString(path);
        final json = jsonDecode(raw) as Map<String, dynamic>;
        if (json['name_ko'] == vehicle.model) {
          catalogJson = json;
          break;
        }
      } catch (_) {}
    }
    if (catalogJson == null) return;

    final catalogItems =
        (catalogJson['items'] as List).cast<Map<String, dynamic>>();
    final catalogKeys = {for (final i in catalogItems) i['id'] as String};

    final dbSpecs = await db.getAllItemSpecs(vehicle.id);
    final dbKeyToSpec = {for (final s in dbSpecs) s.key: s};

    await db.transaction(() async {
      for (final spec in dbSpecs) {
        if (!spec.key.startsWith('custom_') &&
            !catalogKeys.contains(spec.key) &&
            !spec.isHidden) {
          await db.toggleSpecHidden(spec.id, hidden: true);
        }
      }

      for (final item in catalogItems) {
        final key = item['id'] as String;
        final existing = dbKeyToSpec[key];
        if (existing == null) {
          await db.into(db.itemSpecs).insert(
                ItemSpecsCompanion.insert(
                  vehicleId: vehicle.id,
                  key: key,
                  name: item['name_ko'] as String,
                  category: item['category'] as String,
                  intervalKm: Value(item['interval_km'] as int?),
                  intervalMonths: Value(item['interval_months'] as int?),
                  note: Value(item['notes'] as String?),
                  behavior: Value(item['behavior'] as String?),
                  subtitleKo: Value(item['subtitle_ko'] as String?),
                  urgencyThresholdKm: Value(item['urgency_threshold_km'] as int?),
                  urgencyThresholdDays: Value(item['urgency_threshold_days'] as int?),
                ),
              );
        } else {
          // 카탈로그 항목은 JSON을 정본으로 삼아 주기·카테고리·동작 방식 동기화
          await db.syncCatalogSpec(
            existing.id,
            intervalKm: item['interval_km'] as int?,
            intervalMonths: item['interval_months'] as int?,
            category: item['category'] as String,
            behavior: item['behavior'] as String?,
            subtitleKo: item['subtitle_ko'] as String?,
            urgencyThresholdKm: item['urgency_threshold_km'] as int?,
            urgencyThresholdDays: item['urgency_threshold_days'] as int?,
          );
        }
      }
    });
  }

  /// 선택한 카탈로그로 vehicles + item_specs 시드.
  static Future<void> seedFromCatalog(
    AppDatabase db, {
    required String assetPath,
    required int odometer,
  }) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final modelName = json['name_ko'] as String;

    await db.transaction(() async {
      final vehicleId = await db.into(db.vehicles).insert(
            VehiclesCompanion.insert(
              name: modelName,
              model: modelName,
              currentOdometer: Value(odometer),
            ),
          );

      final items = (json['items'] as List).cast<Map<String, dynamic>>();
      for (final item in items) {
        await db.into(db.itemSpecs).insert(
              ItemSpecsCompanion.insert(
                vehicleId: vehicleId,
                key: item['id'] as String,
                name: item['name_ko'] as String,
                category: item['category'] as String,
                intervalKm: Value(item['interval_km'] as int?),
                intervalMonths: Value(item['interval_months'] as int?),
                note: Value(item['notes'] as String?),
                behavior: Value(item['behavior'] as String?),
                subtitleKo: Value(item['subtitle_ko'] as String?),
                urgencyThresholdKm: Value(item['urgency_threshold_km'] as int?),
                urgencyThresholdDays: Value(item['urgency_threshold_days'] as int?),
              ),
            );
      }
    });
  }
}
