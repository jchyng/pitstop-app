class ParsedFuelExpense {
  final String rawMessage;
  final int amount;
  final String? place;
  final DateTime date;

  const ParsedFuelExpense({
    required this.rawMessage,
    required this.amount,
    this.place,
    required this.date,
  });
}

class NotificationParser {
  // 주유소 관련 키워드 (한국 주요 브랜드 + 일반 단어)
  static const _fuelKeywords = [
    '주유소', '주유비', '주유', '셀프주유',
    'GS칼텍스', 'GS Caltex',
    'SK에너지', 'SKE',
    'S-OIL', 'SOIL', '에쓰오일',
    '현대오일뱅크', '오일뱅크',
    '알뜰주유',
  ];

  // 금액 패턴: "44,000원" 또는 "44000원"
  static final _amountRegex =
      RegExp(r'(\d{1,3}(?:,\d{3})+|\d{4,})\s*원');

  // 주유소 이름 추출 패턴
  static final _placePatterns = [
    RegExp(r'GS칼텍스[\s\w가-힣]*'),
    RegExp(r'SK에너지[\s\w가-힣]*'),
    RegExp(r'S-OIL[\s\w가-힣]*'),
    RegExp(r'현대오일뱅크[\s\w가-힣]*'),
    RegExp(r'알뜰주유소[\s\w가-힣]*'),
  ];

  static ParsedFuelExpense? tryParse(Map<dynamic, dynamic> notification) {
    final title = (notification['title'] as String?) ?? '';
    final text = (notification['text'] as String?) ?? '';
    final postTime = (notification['postTime'] as int?) ?? 0;
    final full = '$title $text';

    // 주유 관련 알림인지 판별
    final isFuel = _fuelKeywords.any((kw) => full.contains(kw));
    if (!isFuel) return null;

    // 금액 추출
    final amountMatch = _amountRegex.firstMatch(full);
    if (amountMatch == null) return null;

    final amount = int.tryParse(amountMatch.group(1)!.replaceAll(',', ''));
    if (amount == null || amount <= 0) return null;

    // 주유소 이름 추출 (실패해도 괜찮음)
    String? place;
    for (final pattern in _placePatterns) {
      final match = pattern.firstMatch(full);
      if (match != null) {
        place = match.group(0)?.trim();
        break;
      }
    }

    return ParsedFuelExpense(
      rawMessage: full.trim(),
      amount: amount,
      place: place,
      date: postTime > 0
          ? DateTime.fromMillisecondsSinceEpoch(postTime)
          : DateTime.now(),
    );
  }
}
