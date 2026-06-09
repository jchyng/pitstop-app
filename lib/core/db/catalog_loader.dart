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

  /// 선택한 카탈로그로 vehicles + item_specs 시드.
  static Future<void> seedFromCatalog(
    AppDatabase db, {
    required String assetPath,
    required String nickname,
    required int odometer,
  }) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    await db.transaction(() async {
      final vehicleId = await db.into(db.vehicles).insert(
            VehiclesCompanion.insert(
              name: nickname,
              model: json['name_ko'] as String,
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
              ),
            );
      }
    });
  }
}
