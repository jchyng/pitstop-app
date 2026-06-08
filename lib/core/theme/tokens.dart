import 'package:flutter/material.dart';

abstract final class AppColors {
  static const bg = Color(0xFF0A0C0F);
  static const surface = Color(0xFF15181E);
  static const surface2 = Color(0xFF1A1E26);

  // rgba(255,255,255,0.07)
  static const hairline = Color(0x12FFFFFF);
  // rgba(255,255,255,0.05)
  static const chip = Color(0x0DFFFFFF);

  static const textPrimary = Color(0xFFF4F6F8);
  static const textSecondary = Color(0xFF9BA2AC);
  static const textTertiary = Color(0xFF5E6571);

  static const accent = Color(0xFF4FB0F5);
  static const accent2 = Color(0xFF2E9BE6);
  // rgba(79,176,245,0.16)
  static const accentBg = Color(0x294FB0F5);

  static const amber = Color(0xFFFFB020);
  // rgba(255,176,32,0.14)
  static const amberBg = Color(0x24FFB020);

  static const red = Color(0xFFFF5247);
  // rgba(255,82,71,0.14)
  static const redBg = Color(0x24FF5247);
  static const teal = Color(0xFF3DD6B0);
  // rgba(61,214,176,0.16)
  static const tealBg = Color(0x293DD6B0);
  static const purple = Color(0xFF9B8CFF);
  // rgba(155,140,255,0.16)
  static const purpleBg = Color(0x299B8CFF);
}

abstract final class AppText {
  static const fontFamily = 'Pretendard';

  // 주행거리 히어로 46 / w500
  static const heroOdometer = TextStyle(
    fontSize: 46,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.92, // -0.02em
    fontFeatures: [FontFeature.tabularFigures()],
    height: 1.0,
  );

  // 금액 히어로 40 / w500
  static const heroAmount = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.80,
    fontFeatures: [FontFeature.tabularFigures()],
    height: 1.0,
  );

  // 화면 제목 24 / w500
  static const h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.24,
  );

  // 섹션 헤더 17 / w500
  static const sectionHeader = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // 항목명/값 15 / w500
  static const item = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // 수치 15 / w500 tabular
  static const itemNum = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // 본문 14 / w400
  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // 보조 13 / w400
  static const caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // 라벨/배지 11 / w500
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );
}

abstract final class AppRadius {
  static const card = BorderRadius.all(Radius.circular(22));
  static const innerCard = BorderRadius.all(Radius.circular(18));
  static const button = BorderRadius.all(Radius.circular(12));
  static const badge = BorderRadius.all(Radius.circular(7));
  static const chipShape = BorderRadius.all(Radius.circular(11));
  static const bottomSheet = BorderRadius.vertical(top: Radius.circular(28));
  static const gauge = BorderRadius.all(Radius.circular(3));
}

abstract final class AppSpacing {
  static const sectionGap = 32.0;
  static const cardGap = 14.0;
  static const itemGap = 16.0;
  static const cardPaddingH = 20.0;
  static const cardPaddingV = 22.0;
  static const screenPaddingH = 22.0;
}

// 상태 임계값 (section 3.2)
abstract final class AppThresholds {
  static const warnRatio = 0.15;
  static const warnRemainingKm = 1000;
}
