// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$appInitHash() => r'e4a575e6c3fb9511e021051a8d7c4d1ffbdf9bac';

/// See also [appInit].
@ProviderFor(appInit)
final appInitProvider = AutoDisposeFutureProvider<void>.internal(
  appInit,
  name: r'appInitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appInitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppInitRef = AutoDisposeFutureProviderRef<void>;
String _$vehiclesHash() => r'83a884577c1a23609f47d310a977a39c9e103b62';

/// See also [vehicles].
@ProviderFor(vehicles)
final vehiclesProvider = AutoDisposeFutureProvider<List<Vehicle>>.internal(
  vehicles,
  name: r'vehiclesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vehiclesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VehiclesRef = AutoDisposeFutureProviderRef<List<Vehicle>>;
String _$itemSpecsHash() => r'3bee7b96b6c6dd359615cb4f066df50da0c3ff1e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [itemSpecs].
@ProviderFor(itemSpecs)
const itemSpecsProvider = ItemSpecsFamily();

/// See also [itemSpecs].
class ItemSpecsFamily extends Family<AsyncValue<List<ItemSpec>>> {
  /// See also [itemSpecs].
  const ItemSpecsFamily();

  /// See also [itemSpecs].
  ItemSpecsProvider call(int vehicleId) {
    return ItemSpecsProvider(vehicleId);
  }

  @override
  ItemSpecsProvider getProviderOverride(covariant ItemSpecsProvider provider) {
    return call(provider.vehicleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemSpecsProvider';
}

/// See also [itemSpecs].
class ItemSpecsProvider extends AutoDisposeFutureProvider<List<ItemSpec>> {
  /// See also [itemSpecs].
  ItemSpecsProvider(int vehicleId)
    : this._internal(
        (ref) => itemSpecs(ref as ItemSpecsRef, vehicleId),
        from: itemSpecsProvider,
        name: r'itemSpecsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$itemSpecsHash,
        dependencies: ItemSpecsFamily._dependencies,
        allTransitiveDependencies: ItemSpecsFamily._allTransitiveDependencies,
        vehicleId: vehicleId,
      );

  ItemSpecsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vehicleId,
  }) : super.internal();

  final int vehicleId;

  @override
  Override overrideWith(
    FutureOr<List<ItemSpec>> Function(ItemSpecsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemSpecsProvider._internal(
        (ref) => create(ref as ItemSpecsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vehicleId: vehicleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ItemSpec>> createElement() {
    return _ItemSpecsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemSpecsProvider && other.vehicleId == vehicleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vehicleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemSpecsRef on AutoDisposeFutureProviderRef<List<ItemSpec>> {
  /// The parameter `vehicleId` of this provider.
  int get vehicleId;
}

class _ItemSpecsProviderElement
    extends AutoDisposeFutureProviderElement<List<ItemSpec>>
    with ItemSpecsRef {
  _ItemSpecsProviderElement(super.provider);

  @override
  int get vehicleId => (origin as ItemSpecsProvider).vehicleId;
}

String _$monthlyExpensesHash() => r'1c1e9bb947dc015eff1729138c41891a28e8c7e1';

/// See also [monthlyExpenses].
@ProviderFor(monthlyExpenses)
const monthlyExpensesProvider = MonthlyExpensesFamily();

/// See also [monthlyExpenses].
class MonthlyExpensesFamily extends Family<AsyncValue<List<Expense>>> {
  /// See also [monthlyExpenses].
  const MonthlyExpensesFamily();

  /// See also [monthlyExpenses].
  MonthlyExpensesProvider call(int vehicleId, int year, int month) {
    return MonthlyExpensesProvider(vehicleId, year, month);
  }

  @override
  MonthlyExpensesProvider getProviderOverride(
    covariant MonthlyExpensesProvider provider,
  ) {
    return call(provider.vehicleId, provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyExpensesProvider';
}

/// See also [monthlyExpenses].
class MonthlyExpensesProvider extends AutoDisposeFutureProvider<List<Expense>> {
  /// See also [monthlyExpenses].
  MonthlyExpensesProvider(int vehicleId, int year, int month)
    : this._internal(
        (ref) =>
            monthlyExpenses(ref as MonthlyExpensesRef, vehicleId, year, month),
        from: monthlyExpensesProvider,
        name: r'monthlyExpensesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlyExpensesHash,
        dependencies: MonthlyExpensesFamily._dependencies,
        allTransitiveDependencies:
            MonthlyExpensesFamily._allTransitiveDependencies,
        vehicleId: vehicleId,
        year: year,
        month: month,
      );

  MonthlyExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vehicleId,
    required this.year,
    required this.month,
  }) : super.internal();

  final int vehicleId;
  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<List<Expense>> Function(MonthlyExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyExpensesProvider._internal(
        (ref) => create(ref as MonthlyExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vehicleId: vehicleId,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Expense>> createElement() {
    return _MonthlyExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyExpensesProvider &&
        other.vehicleId == vehicleId &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vehicleId.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyExpensesRef on AutoDisposeFutureProviderRef<List<Expense>> {
  /// The parameter `vehicleId` of this provider.
  int get vehicleId;

  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyExpensesProviderElement
    extends AutoDisposeFutureProviderElement<List<Expense>>
    with MonthlyExpensesRef {
  _MonthlyExpensesProviderElement(super.provider);

  @override
  int get vehicleId => (origin as MonthlyExpensesProvider).vehicleId;
  @override
  int get year => (origin as MonthlyExpensesProvider).year;
  @override
  int get month => (origin as MonthlyExpensesProvider).month;
}

String _$monthlySummaryHash() => r'7fe433ffbf0ff524ba0a809f9c873f963ee113a6';

/// See also [monthlySummary].
@ProviderFor(monthlySummary)
const monthlySummaryProvider = MonthlySummaryFamily();

/// See also [monthlySummary].
class MonthlySummaryFamily extends Family<AsyncValue<ExpenseSummaryData>> {
  /// See also [monthlySummary].
  const MonthlySummaryFamily();

  /// See also [monthlySummary].
  MonthlySummaryProvider call(int vehicleId, int year, int month) {
    return MonthlySummaryProvider(vehicleId, year, month);
  }

  @override
  MonthlySummaryProvider getProviderOverride(
    covariant MonthlySummaryProvider provider,
  ) {
    return call(provider.vehicleId, provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlySummaryProvider';
}

/// See also [monthlySummary].
class MonthlySummaryProvider
    extends AutoDisposeFutureProvider<ExpenseSummaryData> {
  /// See also [monthlySummary].
  MonthlySummaryProvider(int vehicleId, int year, int month)
    : this._internal(
        (ref) =>
            monthlySummary(ref as MonthlySummaryRef, vehicleId, year, month),
        from: monthlySummaryProvider,
        name: r'monthlySummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$monthlySummaryHash,
        dependencies: MonthlySummaryFamily._dependencies,
        allTransitiveDependencies:
            MonthlySummaryFamily._allTransitiveDependencies,
        vehicleId: vehicleId,
        year: year,
        month: month,
      );

  MonthlySummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vehicleId,
    required this.year,
    required this.month,
  }) : super.internal();

  final int vehicleId;
  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<ExpenseSummaryData> Function(MonthlySummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlySummaryProvider._internal(
        (ref) => create(ref as MonthlySummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vehicleId: vehicleId,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ExpenseSummaryData> createElement() {
    return _MonthlySummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlySummaryProvider &&
        other.vehicleId == vehicleId &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vehicleId.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlySummaryRef on AutoDisposeFutureProviderRef<ExpenseSummaryData> {
  /// The parameter `vehicleId` of this provider.
  int get vehicleId;

  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlySummaryProviderElement
    extends AutoDisposeFutureProviderElement<ExpenseSummaryData>
    with MonthlySummaryRef {
  _MonthlySummaryProviderElement(super.provider);

  @override
  int get vehicleId => (origin as MonthlySummaryProvider).vehicleId;
  @override
  int get year => (origin as MonthlySummaryProvider).year;
  @override
  int get month => (origin as MonthlySummaryProvider).month;
}

String _$allMaintenanceRecordsHash() =>
    r'8ef74e45ea61078ae65f0215f3dcd8f15d6aa1cd';

/// See also [allMaintenanceRecords].
@ProviderFor(allMaintenanceRecords)
const allMaintenanceRecordsProvider = AllMaintenanceRecordsFamily();

/// See also [allMaintenanceRecords].
class AllMaintenanceRecordsFamily
    extends Family<AsyncValue<List<RecordWithSpec>>> {
  /// See also [allMaintenanceRecords].
  const AllMaintenanceRecordsFamily();

  /// See also [allMaintenanceRecords].
  AllMaintenanceRecordsProvider call(int vehicleId) {
    return AllMaintenanceRecordsProvider(vehicleId);
  }

  @override
  AllMaintenanceRecordsProvider getProviderOverride(
    covariant AllMaintenanceRecordsProvider provider,
  ) {
    return call(provider.vehicleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allMaintenanceRecordsProvider';
}

/// See also [allMaintenanceRecords].
class AllMaintenanceRecordsProvider
    extends AutoDisposeFutureProvider<List<RecordWithSpec>> {
  /// See also [allMaintenanceRecords].
  AllMaintenanceRecordsProvider(int vehicleId)
    : this._internal(
        (ref) =>
            allMaintenanceRecords(ref as AllMaintenanceRecordsRef, vehicleId),
        from: allMaintenanceRecordsProvider,
        name: r'allMaintenanceRecordsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allMaintenanceRecordsHash,
        dependencies: AllMaintenanceRecordsFamily._dependencies,
        allTransitiveDependencies:
            AllMaintenanceRecordsFamily._allTransitiveDependencies,
        vehicleId: vehicleId,
      );

  AllMaintenanceRecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vehicleId,
  }) : super.internal();

  final int vehicleId;

  @override
  Override overrideWith(
    FutureOr<List<RecordWithSpec>> Function(AllMaintenanceRecordsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllMaintenanceRecordsProvider._internal(
        (ref) => create(ref as AllMaintenanceRecordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vehicleId: vehicleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RecordWithSpec>> createElement() {
    return _AllMaintenanceRecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllMaintenanceRecordsProvider &&
        other.vehicleId == vehicleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vehicleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllMaintenanceRecordsRef
    on AutoDisposeFutureProviderRef<List<RecordWithSpec>> {
  /// The parameter `vehicleId` of this provider.
  int get vehicleId;
}

class _AllMaintenanceRecordsProviderElement
    extends AutoDisposeFutureProviderElement<List<RecordWithSpec>>
    with AllMaintenanceRecordsRef {
  _AllMaintenanceRecordsProviderElement(super.provider);

  @override
  int get vehicleId => (origin as AllMaintenanceRecordsProvider).vehicleId;
}

String _$itemSpecHash() => r'af600f7975214a537c5430c3a1b1c1cda0876bc8';

/// See also [itemSpec].
@ProviderFor(itemSpec)
const itemSpecProvider = ItemSpecFamily();

/// See also [itemSpec].
class ItemSpecFamily extends Family<AsyncValue<ItemSpec?>> {
  /// See also [itemSpec].
  const ItemSpecFamily();

  /// See also [itemSpec].
  ItemSpecProvider call(int specId) {
    return ItemSpecProvider(specId);
  }

  @override
  ItemSpecProvider getProviderOverride(covariant ItemSpecProvider provider) {
    return call(provider.specId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'itemSpecProvider';
}

/// See also [itemSpec].
class ItemSpecProvider extends AutoDisposeFutureProvider<ItemSpec?> {
  /// See also [itemSpec].
  ItemSpecProvider(int specId)
    : this._internal(
        (ref) => itemSpec(ref as ItemSpecRef, specId),
        from: itemSpecProvider,
        name: r'itemSpecProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$itemSpecHash,
        dependencies: ItemSpecFamily._dependencies,
        allTransitiveDependencies: ItemSpecFamily._allTransitiveDependencies,
        specId: specId,
      );

  ItemSpecProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.specId,
  }) : super.internal();

  final int specId;

  @override
  Override overrideWith(
    FutureOr<ItemSpec?> Function(ItemSpecRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ItemSpecProvider._internal(
        (ref) => create(ref as ItemSpecRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        specId: specId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ItemSpec?> createElement() {
    return _ItemSpecProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemSpecProvider && other.specId == specId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, specId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ItemSpecRef on AutoDisposeFutureProviderRef<ItemSpec?> {
  /// The parameter `specId` of this provider.
  int get specId;
}

class _ItemSpecProviderElement
    extends AutoDisposeFutureProviderElement<ItemSpec?>
    with ItemSpecRef {
  _ItemSpecProviderElement(super.provider);

  @override
  int get specId => (origin as ItemSpecProvider).specId;
}

String _$maintenanceRecordsHash() =>
    r'd52da38d7a3e19f8b2ab52e2beb7fd001a016f8b';

/// See also [maintenanceRecords].
@ProviderFor(maintenanceRecords)
const maintenanceRecordsProvider = MaintenanceRecordsFamily();

/// See also [maintenanceRecords].
class MaintenanceRecordsFamily
    extends Family<AsyncValue<List<MaintenanceRecord>>> {
  /// See also [maintenanceRecords].
  const MaintenanceRecordsFamily();

  /// See also [maintenanceRecords].
  MaintenanceRecordsProvider call(int specId) {
    return MaintenanceRecordsProvider(specId);
  }

  @override
  MaintenanceRecordsProvider getProviderOverride(
    covariant MaintenanceRecordsProvider provider,
  ) {
    return call(provider.specId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'maintenanceRecordsProvider';
}

/// See also [maintenanceRecords].
class MaintenanceRecordsProvider
    extends AutoDisposeFutureProvider<List<MaintenanceRecord>> {
  /// See also [maintenanceRecords].
  MaintenanceRecordsProvider(int specId)
    : this._internal(
        (ref) => maintenanceRecords(ref as MaintenanceRecordsRef, specId),
        from: maintenanceRecordsProvider,
        name: r'maintenanceRecordsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$maintenanceRecordsHash,
        dependencies: MaintenanceRecordsFamily._dependencies,
        allTransitiveDependencies:
            MaintenanceRecordsFamily._allTransitiveDependencies,
        specId: specId,
      );

  MaintenanceRecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.specId,
  }) : super.internal();

  final int specId;

  @override
  Override overrideWith(
    FutureOr<List<MaintenanceRecord>> Function(MaintenanceRecordsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MaintenanceRecordsProvider._internal(
        (ref) => create(ref as MaintenanceRecordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        specId: specId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MaintenanceRecord>> createElement() {
    return _MaintenanceRecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MaintenanceRecordsProvider && other.specId == specId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, specId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MaintenanceRecordsRef
    on AutoDisposeFutureProviderRef<List<MaintenanceRecord>> {
  /// The parameter `specId` of this provider.
  int get specId;
}

class _MaintenanceRecordsProviderElement
    extends AutoDisposeFutureProviderElement<List<MaintenanceRecord>>
    with MaintenanceRecordsRef {
  _MaintenanceRecordsProviderElement(super.provider);

  @override
  int get specId => (origin as MaintenanceRecordsProvider).specId;
}

String _$sortedItemStatusHash() => r'a6bcb5f582b7a7f27935202d28ec52d88dbf450f';

/// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
///
/// Copied from [sortedItemStatus].
@ProviderFor(sortedItemStatus)
const sortedItemStatusProvider = SortedItemStatusFamily();

/// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
///
/// Copied from [sortedItemStatus].
class SortedItemStatusFamily extends Family<AsyncValue<List<ItemStatusEntry>>> {
  /// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
  ///
  /// Copied from [sortedItemStatus].
  const SortedItemStatusFamily();

  /// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
  ///
  /// Copied from [sortedItemStatus].
  SortedItemStatusProvider call(int vehicleId) {
    return SortedItemStatusProvider(vehicleId);
  }

  @override
  SortedItemStatusProvider getProviderOverride(
    covariant SortedItemStatusProvider provider,
  ) {
    return call(provider.vehicleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sortedItemStatusProvider';
}

/// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
///
/// Copied from [sortedItemStatus].
class SortedItemStatusProvider
    extends AutoDisposeFutureProvider<List<ItemStatusEntry>> {
  /// 소모품 남은 수명 계산 결과, ratio 오름차순 정렬(unknown 맨 끝).
  ///
  /// Copied from [sortedItemStatus].
  SortedItemStatusProvider(int vehicleId)
    : this._internal(
        (ref) => sortedItemStatus(ref as SortedItemStatusRef, vehicleId),
        from: sortedItemStatusProvider,
        name: r'sortedItemStatusProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sortedItemStatusHash,
        dependencies: SortedItemStatusFamily._dependencies,
        allTransitiveDependencies:
            SortedItemStatusFamily._allTransitiveDependencies,
        vehicleId: vehicleId,
      );

  SortedItemStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vehicleId,
  }) : super.internal();

  final int vehicleId;

  @override
  Override overrideWith(
    FutureOr<List<ItemStatusEntry>> Function(SortedItemStatusRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SortedItemStatusProvider._internal(
        (ref) => create(ref as SortedItemStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vehicleId: vehicleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ItemStatusEntry>> createElement() {
    return _SortedItemStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortedItemStatusProvider && other.vehicleId == vehicleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vehicleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortedItemStatusRef
    on AutoDisposeFutureProviderRef<List<ItemStatusEntry>> {
  /// The parameter `vehicleId` of this provider.
  int get vehicleId;
}

class _SortedItemStatusProviderElement
    extends AutoDisposeFutureProviderElement<List<ItemStatusEntry>>
    with SortedItemStatusRef {
  _SortedItemStatusProviderElement(super.provider);

  @override
  int get vehicleId => (origin as SortedItemStatusProvider).vehicleId;
}

String _$allItemSpecsHash() => r'69a160e3ea3b95edc90d2760256acee9db65e92a';

/// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
///
/// Copied from [allItemSpecs].
@ProviderFor(allItemSpecs)
const allItemSpecsProvider = AllItemSpecsFamily();

/// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
///
/// Copied from [allItemSpecs].
class AllItemSpecsFamily extends Family<AsyncValue<List<ItemSpec>>> {
  /// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
  ///
  /// Copied from [allItemSpecs].
  const AllItemSpecsFamily();

  /// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
  ///
  /// Copied from [allItemSpecs].
  AllItemSpecsProvider call(int vehicleId) {
    return AllItemSpecsProvider(vehicleId);
  }

  @override
  AllItemSpecsProvider getProviderOverride(
    covariant AllItemSpecsProvider provider,
  ) {
    return call(provider.vehicleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allItemSpecsProvider';
}

/// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
///
/// Copied from [allItemSpecs].
class AllItemSpecsProvider extends AutoDisposeFutureProvider<List<ItemSpec>> {
  /// 관리 화면용: 숨긴 항목 포함 전체 스펙 목록.
  ///
  /// Copied from [allItemSpecs].
  AllItemSpecsProvider(int vehicleId)
    : this._internal(
        (ref) => allItemSpecs(ref as AllItemSpecsRef, vehicleId),
        from: allItemSpecsProvider,
        name: r'allItemSpecsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allItemSpecsHash,
        dependencies: AllItemSpecsFamily._dependencies,
        allTransitiveDependencies:
            AllItemSpecsFamily._allTransitiveDependencies,
        vehicleId: vehicleId,
      );

  AllItemSpecsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vehicleId,
  }) : super.internal();

  final int vehicleId;

  @override
  Override overrideWith(
    FutureOr<List<ItemSpec>> Function(AllItemSpecsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllItemSpecsProvider._internal(
        (ref) => create(ref as AllItemSpecsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vehicleId: vehicleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ItemSpec>> createElement() {
    return _AllItemSpecsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllItemSpecsProvider && other.vehicleId == vehicleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vehicleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllItemSpecsRef on AutoDisposeFutureProviderRef<List<ItemSpec>> {
  /// The parameter `vehicleId` of this provider.
  int get vehicleId;
}

class _AllItemSpecsProviderElement
    extends AutoDisposeFutureProviderElement<List<ItemSpec>>
    with AllItemSpecsRef {
  _AllItemSpecsProviderElement(super.provider);

  @override
  int get vehicleId => (origin as AllItemSpecsProvider).vehicleId;
}

String _$scheduleNotificationsHash() =>
    r'd6e427b342174376844357fb1c0c44e098b4857f';

/// vehicles + sortedItemStatus 를 watch해 소모품 상태 변경 시 자동으로
/// 로컬 알림을 재스케줄한다. MainShell에서 ref.watch만 하면 된다.
///
/// Copied from [scheduleNotifications].
@ProviderFor(scheduleNotifications)
final scheduleNotificationsProvider = AutoDisposeFutureProvider<void>.internal(
  scheduleNotifications,
  name: r'scheduleNotificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleNotificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduleNotificationsRef = AutoDisposeFutureProviderRef<void>;
String _$fuelNotificationStreamHash() =>
    r'3408e3493cb0b6e3da61d7593c50ca9413aa5309';

/// Android NotificationListenerService 원시 스트림 → 주유비만 필터링.
///
/// Copied from [fuelNotificationStream].
@ProviderFor(fuelNotificationStream)
final fuelNotificationStreamProvider =
    StreamProvider<ParsedFuelExpense>.internal(
      fuelNotificationStream,
      name: r'fuelNotificationStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fuelNotificationStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FuelNotificationStreamRef = StreamProviderRef<ParsedFuelExpense>;
String _$notificationPermissionHash() =>
    r'708d2cfb672772b2c31e1841006ee101e1d7947d';

/// 알림 접근 권한 여부 (앱 포그라운드 진입 시 확인).
///
/// Copied from [notificationPermission].
@ProviderFor(notificationPermission)
final notificationPermissionProvider = AutoDisposeFutureProvider<bool>.internal(
  notificationPermission,
  name: r'notificationPermissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPermissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPermissionRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
