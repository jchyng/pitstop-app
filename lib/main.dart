import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/local_notification_service.dart';
import 'features/maintenance/item_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 초기화 + 탭 시 소모품 상세로 이동
  LocalNotificationService.onTapped = (specId) {
    final vehicleId = LocalNotificationService.currentVehicleId;
    if (vehicleId == null) return;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) =>
            ItemDetailScreen(specId: specId, vehicleId: vehicleId),
      ),
    );
  };
  await LocalNotificationService.initialize();

  runApp(const ProviderScope(child: App()));
}
