import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'database.dart';

/// assets/catalog/ 의 JSON을 파싱해 vehicles + item_specs 행을 삽입한다.
/// 이미 시드된 경우 skip (vehicles 테이블 비어있을 때만 실행).
class CatalogLoader {
  static Future<void> seedIfEmpty(AppDatabase db) async {
    final existing = await db.select(db.vehicles).get();
    if (existing.isNotEmpty) return;

    // 현재 프로젝트에 있는 카탈로그 파일
    const assetPath = 'assets/catalog/rexton-sports-khan-diesel.json';
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    await db.transaction(() async {
      // 1) 차량 등록
      final vehicleId = await db.into(db.vehicles).insert(
            VehiclesCompanion.insert(
              name: json['name_ko'] as String,
              model: json['name_ko'] as String,
              currentOdometer: const Value(0),
            ),
          );

      // 2) 소모품 항목 복사
      final items = (json['items'] as List).cast<Map<String, dynamic>>();
      for (final item in items) {
        await db.into(db.itemSpecs).insert(
              ItemSpecsCompanion.insert(
                vehicleId: vehicleId,
                key: item['id'] as String,
                name: item['name_ko'] as String,
                category: item['category'] as String,
                intervalKm:
                    Value(item['interval_km'] as int?),
                intervalMonths:
                    Value(item['interval_months'] as int?),
                note: Value(item['notes'] as String?),
                behavior: Value(item['behavior'] as String?),
              ),
            );
      }
    });
  }
}
