import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String fmtKm(int km) => NumberFormat('#,##0').format(km);

String fmtKrw(int amount) => NumberFormat('#,##0').format(amount);

/// 목록 등 짧은 날짜: YY.MM.DD
String fmtDateShort(DateTime d) =>
    '${(d.year % 100).toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

/// 폼/상세 등 전체 날짜: 2026.06.09
String fmtDateFull(DateTime d) =>
    '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

/// 숫자 입력 필드 천 단위 구분 포맷터.
/// 입력 중에도 ,를 자동 삽입한다. 파싱 시 .replaceAll(',', '') 필요.
class ThousandsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    if (!RegExp(r'^\d+$').hasMatch(digits)) return oldValue;
    final n = int.tryParse(digits);
    if (n == null) return oldValue;
    final formatted = NumberFormat('#,##0').format(n);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
