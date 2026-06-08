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
String _$appInitHash() => r'29f91ba345e7f5cf119768ea6b373d2970e3a87d';

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

String _$sortedItemStatusHash() => r'620ae263031a8c0b0cd5d90018833995e8d9c4e4';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
