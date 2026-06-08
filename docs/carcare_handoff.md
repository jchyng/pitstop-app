# 차량 관리 앱 — 개발 핸드오프 문서

> 국내 차량(현대) 1종으로 작게 시작하는 차량 소모품 관리 + 유지비 가계부 앱.
> 이 문서 + 목업 HTML(`dashboard_simple.html`, `item_detail_history.html`, `expense_book.html`)을 함께 참고해 Flutter로 구현한다.

---

## 0. 합의된 결정 사항 (Decision Log)

- **MVP 범위**: 소모품 교체 주기 추적 + 교체 이력 CRUD + 유지비 가계부.
- **데이터 입력**: 정비 이력·유지비는 **수기 입력**이 기본. 유류비는 안드로이드 **알림 내용 파싱(NotificationListenerService)** 으로 보조 자동화(= 후순위, MVP 이후).
- **카탈로그 데이터**: 차량 정비지침서/취급설명서를 직접 수집 → AI로 파싱 → 정형 JSON으로 앱에 내장. 런타임 PDF 파싱은 하지 않음.
- **첫 타겟**: 현대차 1종(예시: 그랜저 GN7). 다차량은 구조만 열어두고 기능은 후순위.
- **디자인**: BMW 앱 스타일의 다크 프리미엄. "디지털 계기판" 컨셉, 주행거리를 주인공으로. 폰트 Pretendard.

### 비범위 (Deferred / Out of Scope)
- 알림 파싱 자동 유류비 입력 (안드로이드 전용, MVP 이후)
- iOS 문자/알림 자동 유류비 (플랫폼상 불가 → 수기만)
- 인앱 PDF 파싱, 클라우드 동기화, 다차량 관리

---

## 1. 디자인 시스템

목업 HTML에서 그대로 추출한 토큰. Flutter `ThemeData` + `lib/core/theme/tokens.dart`로 옮긴다.

### 1.1 색상 (Color Tokens)

| 토큰 | 값 | 용도 |
|---|---|---|
| `bg` | `#0A0C0F` | 화면 배경(다크) |
| `surface` | `#15181E` | 카드 표면 |
| `surface2` | `#1A1E26` | 바텀시트 등 상위 표면 |
| `hairline` | `rgba(255,255,255,0.07)` | 1px 경계선/구분선 |
| `chip` | `rgba(255,255,255,0.05)` | 아이콘 칩/은은한 배경 |
| `textPrimary` | `#F4F6F8` | 본문/수치 |
| `textSecondary` | `#9BA2AC` | 보조 텍스트 |
| `textTertiary` | `#5E6571` | 라벨/힌트 |
| `accent` | `#4FB0F5` | 주 액센트(블루) |
| `accent2` | `#2E9BE6` | 게이지 그라데이션 끝색 |
| `accentBg` | `rgba(79,176,245,0.16)` | 액센트 배경/배지 |
| `amber` | `#FFB020` | 경고(교체 권장) |
| `red` | `#FF5247` | 임박/초과 |
| `teal` | `#3DD6B0` | 카테고리: 정비·소모품 |
| `purple` | `#9B8CFF` | 카테고리: 보험·세금 |

상태 색 매핑: 정상 = `accent` 그라데이션, 교체 권장 = `amber`, 임박/초과 = `red`.
가계부 카테고리 색: 주유 = `accent`, 정비·소모품 = `teal`, 보험·세금 = `purple`, 주차·통행 = `amber`.

### 1.2 타이포그래피
- **폰트**: Pretendard. (`google_fonts`에 없음 → `.otf`/`.ttf`를 `assets/fonts/`에 번들하고 `pubspec.yaml`에 등록)
- **웨이트**: 400(Regular), 500(Medium) 두 종만 사용.
- **수치(주행거리·금액)**: tabular figures(`fontFeatures: [FontFeature.tabularFigures()]`), 큰 수치는 `letterSpacing: -0.02`.

| 역할 | 크기 | 웨이트 |
|---|---|---|
| 주행거리 히어로 | 46 | 500 |
| 금액/상태 히어로 | 38–40 | 500 |
| 화면 제목 (h1) | 22–24 | 500 |
| 네비/섹션 헤더 | 16–17 | 500 |
| 항목명/값 | 15 | 500 |
| 본문/보조 | 13–14 | 400 |
| 라벨/배지 | 11–12 | 400–500 |

### 1.3 형태·간격
- **Radius**: 카드 `22`, 내부 카드/거래행 `18`, 인풋/버튼 `12–14`, 배지/칩 `7–11`.
- **카드 패딩**: `22 x 20`(상태 카드), 리스트형 카드 `4–8 x 18–20`.
- **간격 리듬**: 섹션 간 `30–34`, 카드 간 `14`, 항목 내부 `13–18`.
- **단방향 보더(border-left 등)에는 라운드 금지** — 풀 보더에만 라운드.

### 1.4 핵심 컴포넌트 스펙
- **게이지(progress)**: 높이 5–6, radius 3, 트랙 `rgba(255,255,255,0.06)`, fill 은 정상=`accent2→accent` 90° 그라데이션 / 경고=solid `amber`. 진입 시 width 0→값 애니메이션(~1s, easeOutCubic).
- **상태 칩/배지**: "교체 권장" = `amberBg` 배경 + `amber` 텍스트. "자동"(알림) = `accentBg` + `accent` + 번개 아이콘.
- **타임라인(이력)**: 좌측 레일(점 + 세로선), 최신 항목 점은 `accent` + 외곽 글로우(`box-shadow 0 0 0 4px accentBg`).
- **세그먼트 컨트롤**: 트랙 `chip`, 선택 탭 `accentBg`+`accent`.
- **인풋**: 배경 `rgba(255,255,255,0.04)`, 보더 `hairline`, radius 12, 패딩 14.
- **바텀시트**: 상단 라운드 28, 그래버 바, 백드롭 `rgba(0,0,0,0.5)`. Flutter: `showModalBottomSheet` + `DraggableScrollableSheet`.
- **하단 탭바**: 홈 / 정비이력 / 가계부 / 더보기, 활성 = `accent`. 가계부 화면엔 우하단 FAB(+).

---

## 2. 데이터 모델

로컬 우선(SQLite). 관계형 + 집계 쿼리(월별 통계, km당 비용) 때문에 **Drift(SQLite)** 권장.
금액은 원(KRW) 정수로 저장(소수 없음). 날짜는 `DateTime`(date-only는 자정 기준).

### 2.1 테이블

**vehicles**

| 필드 | 타입 | 비고 |
|---|---|---|
| id | int PK | |
| name | text | 별칭 (예: "내 그랜저") |
| model | text | 예: "그랜저 GN7" |
| trim | text? | 예: "캘리그래피 하이브리드" |
| year | int? | |
| current_odometer | int | 현재 누적 주행거리(km) — 게이지 계산의 기준 |
| registered_at | datetime | |

**item_specs** — 카탈로그 JSON에서 차량 등록 시 복사 생성(차량별 소모품 정의)

| 필드 | 타입 | 비고 |
|---|---|---|
| id | int PK | |
| vehicle_id | int FK→vehicles | |
| key | text | 예: "engine_oil" (안정적 식별자) |
| name | text | 예: "엔진오일 및 필터" |
| category | text | engine / filter / brake / coolant ... |
| interval_km | int? | 거리 주기 |
| interval_months | int? | 시간 주기 |
| severe_interval_km | int? | 가혹 조건 주기(선택) |
| note | text? | 예: "합성유 0W-20" |
| last_replaced_odometer | int? | 최신 '교체' 기록에서 캐시(파생) |
| last_replaced_date | datetime? | 최신 '교체' 기록에서 캐시(파생) |

**maintenance_records** — 교체/점검 이력

| 필드 | 타입 | 비고 |
|---|---|---|
| id | int PK | |
| vehicle_id | int FK | |
| item_spec_id | int? FK→item_specs | null이면 비정형 기록 |
| type | text(enum) | replace(교체) / inspect(점검) / refill(보충) |
| date | datetime | |
| odometer | int | **교체 시점 누적 주행거리** (가장 중요한 입력값) |
| place | text? | 정비소/장소 |
| memo | text? | |
| expense_id | int? FK→expenses | 비용이 있을 때 연결 |
| created_at | datetime | |

**expenses** — 가계부의 단일 원장(모든 지출의 단일 출처)

| 필드 | 타입 | 비고 |
|---|---|---|
| id | int PK | |
| vehicle_id | int FK | |
| category | text(enum) | fuel / maintenance / insurance_tax / parking_toll / etc |
| title | text | 예: "주유", "엔진오일 교체" |
| place | text? | 예: "GS칼텍스 강남" |
| date | datetime | |
| amount | int | 원(KRW) |
| source | text(enum) | manual(수기) / auto(알림 파싱) |
| raw_message | text? | auto일 때 원본 알림 텍스트(검증용) |
| created_at | datetime | |

### 2.2 관계 핵심 결정 — 이력 ↔ 가계부
- **expenses 가 돈에 대한 단일 출처**다. 가계부 화면은 expenses만 집계한다.
- 비용이 발생한 **정비 기록을 저장하면, 같은 트랜잭션에서 expense(category=maintenance) 한 건을 생성하고 `maintenance_records.expense_id`로 연결**한다.
- 한쪽을 삭제하면 연결된 다른 쪽도 함께 정리(또는 연결 해제)한다.
- 따라서: 엔진오일 교체 1회 기록 → ① 이력 추가 ② 가계부 지출 자동 반영 ③ 소모품 게이지 갱신, 세 가지가 한 번의 입력으로 일관되게 일어난다.

---

## 3. 핵심 계산 로직

### 3.1 남은 수명(소모품)
각 `item_spec`에 대해 거리·시간 두 축을 계산하고 **더 임박한 쪽**을 채택한다.

```
// 거리 기준
remainingKm   = last_replaced_odometer + interval_km - vehicle.current_odometer
ratioKm       = remainingKm / interval_km            // 0..1 (남은 비율)

// 시간 기준 (interval_months 가 있을 때)
dueDate        = last_replaced_date + interval_months(개월)
remainingDays  = dueDate - today
ratioTime      = remainingDays / (interval_months * 30.4)

// 화면에 쓰는 대표값 = 더 임박한 축
ratio          = min(ratioKm, ratioTime)             // 둘 중 하나만 있으면 그것만
```

- 게이지 표시는 `clamp(ratio, 0, 1)` 비율로 채운다.
- "남은 거리" 텍스트는 거리축이 더 임박하면 `remainingKm km 남음`, 시간축이면 `D-n` 형태로 표기 가능.

### 3.2 상태(state) 임계값
```
overdue (red)   : ratio <= 0                  // 주기 초과
warn   (amber)  : ratio <= 0.15  OR  remainingKm <= 1000   // 교체 권장
ok     (accent) : 그 외
```
임계값(0.15 / 1000km)은 상수로 분리해 조정 가능하게 둔다.

### 3.3 current_odometer 갱신 (정확도의 핵심)
- `vehicles.current_odometer`는 **저장 필드**이며 게이지 계산의 기준.
- 갱신 경로: ① 사용자가 직접 수정, ② 정비/주유 기록 저장 시 입력한 odometer 가 현재값보다 크면 자동으로 끌어올림.
- 권장 UX: 앱 진입/주기적으로 "현재 주행거리 업데이트" 유도. 미갱신 시 게이지는 마지막 값 기준으로 보수적으로 표시.

### 3.4 가계부 집계
- 이번 달 총 지출 = 해당 월 expenses.amount 합.
- 카테고리 분석 = category별 합 + 비율.
- km당 유지비 = (기간 총 지출) / (기간 주행거리). 기간 주행거리는 해당 기간 odometer 증가분으로 산출.

---

## 4. 카탈로그 JSON 스키마

직접 수집 → AI 파싱으로 만들 데이터의 형식. 차량 등록 시 이 JSON을 읽어 `item_specs` 행으로 복사한다.

```json
{
  "model": "그랜저 GN7",
  "trim": "캘리그래피 하이브리드",
  "year": 2024,
  "source": "현대자동차 취급설명서 / 정비지침서",
  "items": [
    {
      "key": "engine_oil",
      "name": "엔진오일 및 필터",
      "category": "engine",
      "interval_km": 15000,
      "interval_months": 12,
      "severe_interval_km": 7500,
      "note": "합성유 0W-20"
    },
    {
      "key": "air_cleaner_filter",
      "name": "에어 클리너 필터",
      "category": "filter",
      "interval_km": 40000,
      "interval_months": null
    },
    {
      "key": "cabin_filter",
      "name": "에어컨 필터",
      "category": "filter",
      "interval_km": 15000,
      "interval_months": null
    },
    {
      "key": "brake_fluid",
      "name": "브레이크 오일",
      "category": "brake",
      "interval_km": 50000,
      "interval_months": 24
    },
    {
      "key": "coolant",
      "name": "냉각수",
      "category": "coolant",
      "interval_km": 200000,
      "interval_months": 120
    }
  ]
}
```

규칙: `interval_km` / `interval_months`는 둘 중 하나 이상 필수(둘 다 있으면 더 임박한 쪽 적용). `severe_interval_km`, `note`는 선택. `key`는 영문 스네이크케이스로 안정적 식별자 역할.

---

## 5. 화면 ↔ 목업 매핑

| 기능(feature) | 목업 파일 | 비고 |
|---|---|---|
| 홈 / 차고 (소모품 현황) | `dashboard_simple.html` | 항목 탭 → 상세로 이동 |
| 소모품 상세 + 교체 이력(CRUD) | `item_detail_history.html` | 상단=조회, 하단=추가/수정 시트 |
| 유지비 가계부 | `expense_book.html` | 도넛 분석 + 내역 + FAB |
| 차량 등록 / 온보딩 | (미작성) | 카탈로그 JSON 연결 첫 진입 |
| 통합 기록 추가 폼 | (미작성) | 주유/정비/지출 단일 입력 |

### HTML → Flutter 번역 주의
- 폰 프레임/노치/상태바는 목업용 → 구현 시 무시.
- CSS 게이지 → `Container` + `LinearGradient` (또는 `Stack`).
- conic-gradient 도넛 → `fl_chart`의 `PieChart`(도넛형) 또는 `CustomPainter`.
- 바텀시트 → `showModalBottomSheet(isScrollControlled: true)` + `DraggableScrollableSheet`.
- 진입 애니메이션(staggered rise) → `AnimatedOpacity`/`TweenAnimationBuilder` 또는 `flutter_animate`.
- 천단위 콤마/통화/날짜 포맷 → `intl` 패키지.

---

## 6. Flutter 구현 가이드

### 6.1 스택
- **상태관리**: Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **로컬 DB**: Drift (`drift`, `drift_flutter`, `sqlite3_flutter_libs`)
- **차트**: `fl_chart`
- **포맷**: `intl`
- **폰트**: Pretendard 에셋 번들
- (애니메이션 보조) `flutter_animate` 선택

### 6.2 프로젝트 구조 (feature-first)
```
lib/
  core/
    theme/        // tokens.dart, app_theme.dart (ThemeData)
    db/           // drift database, tables, daos
    util/         // formatters, date/odometer helpers
  domain/
    models/       // Vehicle, ItemSpec, MaintenanceRecord, Expense
    logic/        // remaining-life, status, aggregation
  features/
    garage/       // 홈/대시보드 (소모품 현황)
    maintenance/  // 소모품 상세 + 이력 CRUD
    expense/      // 가계부
    onboarding/   // 차량 등록 (카탈로그 로드)
  app.dart        // 라우팅, 탭 셸
assets/
  fonts/          // Pretendard
  catalog/        // 차량 카탈로그 JSON
```

### 6.3 빌드 순서 (수직 슬라이스)
정적 화면을 먼저 다 만들지 말고, 데이터-계산까지 한 기능씩 끝까지 완성한다.
1. **기반**: 테마/토큰, Drift 스키마, 차량 등록(카탈로그 JSON → item_specs).
2. **홈(대시보드)**: current_odometer 입력 → 남은 수명 계산 → 게이지/상태/경고까지 실제 데이터로.
3. **소모품 상세 + 이력 CRUD**: 기록 추가 시 last_replaced 캐시 갱신 + 게이지 자동 반영.
4. **가계부**: expenses 집계(월 합/카테고리/도넛/km당 비용) + 정비 기록 연동 검증.
5. (이후) 안드로이드 알림 파싱 보조 입력.

### 6.4 첫 작업 지시 예시 (Claude Code용)
> "이 핸드오프 문서와 3개 HTML 목업을 기준으로 Flutter 프로젝트를 시작한다. 1단계로 (a) `core/theme` 토큰·다크 ThemeData, (b) Pretendard 폰트 등록, (c) Drift 스키마(vehicles/item_specs/maintenance_records/expenses), (d) `assets/catalog/grandeur_gn7.json` 로드해 차량 등록하는 흐름까지 구현하라. 화면 비주얼은 `dashboard_simple.html`을 그대로 따른다."

---

## 7. 체크리스트 (구현 전 확정 완료 여부)
- [x] 디자인 토큰(색/타이포/형태)
- [x] 데이터 모델 + 테이블
- [x] 이력 ↔ 가계부 관계(단일 원장 + 연결)
- [x] 남은 수명 계산식 + 상태 임계값
- [x] current_odometer 갱신 정책
- [x] 카탈로그 JSON 스키마
- [ ] 차량 등록/온보딩 화면 디자인 (구현 중 확정)
- [ ] 통합 기록 추가 폼 디자인 (구현 중 확정)
