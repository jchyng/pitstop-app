import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/tokens.dart';
import 'core/theme/tokens.dart' show AppColors, AppText;
import 'core/utils/format.dart';
import 'core/utils/notification_parser.dart';
import 'features/garage/garage_screen.dart';
import 'features/maintenance/maintenance_screen.dart';
import 'features/expense/expense_screen.dart';
import 'features/more/more_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'providers.dart';

/// 알림 탭 딥링크에 사용되는 전역 navigator key.
final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitstop',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: const _RootRouter(),
    );
  }
}

// ─── 루트 라우터 ─────────────────────────────────────────────────

class _RootRouter extends ConsumerWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(appInitProvider);

    return initAsync.when(
      loading: () => const _SplashScreen(),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Text('초기화 오류: $e',
              style: const TextStyle(color: AppColors.textSecondary)),
        ),
      ),
      data: (_) {
        final vehiclesAsync = ref.watch(vehiclesProvider);
        return vehiclesAsync.when(
          loading: () => const _SplashScreen(),
          error: (e, _) => Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: Text('오류: $e',
                  style: const TextStyle(color: AppColors.textSecondary)),
            ),
          ),
          data: (vehicles) =>
              vehicles.isEmpty ? const OnboardingScreen() : const MainShell(),
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      GarageScreen(onNavigateToMore: () => setState(() => _selectedIndex = 3)),
      const MaintenanceScreen(),
      const ExpenseScreen(),
      const MoreScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 주유비 자동 감지 → 가계부 자동 저장
    ref.listen<AsyncValue<ParsedFuelExpense>>(
      fuelNotificationStreamProvider,
      (_, next) => next.whenData(_autoSaveFuel),
    );

    // 소모품 상태 변경 시 알림 재스케줄 (의존성 변경 시 자동 재실행)
    ref.watch(scheduleNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _PitstopTabBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }

  Future<void> _autoSaveFuel(ParsedFuelExpense expense) async {
    final vehicles = await ref.read(vehiclesProvider.future);
    if (vehicles.isEmpty) return;
    final vehicleId = vehicles.first.id;

    await ref.read(appDatabaseProvider).addExpenseManually(
          vehicleId: vehicleId,
          category: 'fuel',
          title: '주유',
          date: expense.date,
          amount: expense.amount,
          place: expense.place,
          source: 'auto',
          rawMessage: expense.rawMessage,
        );

    ref.invalidate(monthlyExpensesProvider(vehicleId, expense.date.year, expense.date.month));
    ref.invalidate(monthlySummaryProvider(vehicleId, expense.date.year, expense.date.month));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 16),
              const SizedBox(width: 8),
              Text(
                '주유비 ₩${fmtKrw(expense.amount)} 자동 기록됨',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: AppText.fontFamily,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1A1E26),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
    }
  }
}

class _PitstopTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _PitstopTabBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xF00D0F13),
        border: Border(top: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: [
          _Tab(
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: '홈',
            active: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _Tab(
            icon: Icons.history_outlined,
            activeIcon: Icons.history_rounded,
            label: '정비이력',
            active: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _Tab(
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet_rounded,
            label: '가계부',
            active: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _Tab(
            icon: Icons.more_horiz_rounded,
            activeIcon: Icons.more_horiz_rounded,
            label: '더보기',
            active: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.accent : AppColors.textTertiary;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 활성 인디케이터
            AnimatedOpacity(
              opacity: active ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 20,
                height: 3,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
            Icon(active ? activeIcon : icon, size: 24, color: color),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontFamily: AppText.fontFamily,
                fontWeight: active ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
