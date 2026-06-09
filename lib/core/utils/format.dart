import 'package:intl/intl.dart';

String fmtKm(int km) => NumberFormat('#,##0').format(km);

String fmtKrw(int amount) => NumberFormat('#,##0').format(amount);

/// 목록 등 짧은 날짜: 06.09
String fmtDateShort(DateTime d) =>
    '${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

/// 폼/상세 등 전체 날짜: 2026.06.09
String fmtDateFull(DateTime d) =>
    '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
