// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trimMeta = const VerificationMeta('trim');
  @override
  late final GeneratedColumn<String> trim = GeneratedColumn<String>(
    'trim',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentOdometerMeta = const VerificationMeta(
    'currentOdometer',
  );
  @override
  late final GeneratedColumn<int> currentOdometer = GeneratedColumn<int>(
    'current_odometer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _registeredAtMeta = const VerificationMeta(
    'registeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> registeredAt = GeneratedColumn<DateTime>(
    'registered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    model,
    trim,
    year,
    currentOdometer,
    registeredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('trim')) {
      context.handle(
        _trimMeta,
        trim.isAcceptableOrUnknown(data['trim']!, _trimMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('current_odometer')) {
      context.handle(
        _currentOdometerMeta,
        currentOdometer.isAcceptableOrUnknown(
          data['current_odometer']!,
          _currentOdometerMeta,
        ),
      );
    }
    if (data.containsKey('registered_at')) {
      context.handle(
        _registeredAtMeta,
        registeredAt.isAcceptableOrUnknown(
          data['registered_at']!,
          _registeredAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      trim: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trim'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      currentOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_odometer'],
      )!,
      registeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registered_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String name;
  final String model;
  final String? trim;
  final int? year;
  final int currentOdometer;
  final DateTime registeredAt;
  const Vehicle({
    required this.id,
    required this.name,
    required this.model,
    this.trim,
    this.year,
    required this.currentOdometer,
    required this.registeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || trim != null) {
      map['trim'] = Variable<String>(trim);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['current_odometer'] = Variable<int>(currentOdometer);
    map['registered_at'] = Variable<DateTime>(registeredAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      model: Value(model),
      trim: trim == null && nullToAbsent ? const Value.absent() : Value(trim),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      currentOdometer: Value(currentOdometer),
      registeredAt: Value(registeredAt),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      model: serializer.fromJson<String>(json['model']),
      trim: serializer.fromJson<String?>(json['trim']),
      year: serializer.fromJson<int?>(json['year']),
      currentOdometer: serializer.fromJson<int>(json['currentOdometer']),
      registeredAt: serializer.fromJson<DateTime>(json['registeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'model': serializer.toJson<String>(model),
      'trim': serializer.toJson<String?>(trim),
      'year': serializer.toJson<int?>(year),
      'currentOdometer': serializer.toJson<int>(currentOdometer),
      'registeredAt': serializer.toJson<DateTime>(registeredAt),
    };
  }

  Vehicle copyWith({
    int? id,
    String? name,
    String? model,
    Value<String?> trim = const Value.absent(),
    Value<int?> year = const Value.absent(),
    int? currentOdometer,
    DateTime? registeredAt,
  }) => Vehicle(
    id: id ?? this.id,
    name: name ?? this.name,
    model: model ?? this.model,
    trim: trim.present ? trim.value : this.trim,
    year: year.present ? year.value : this.year,
    currentOdometer: currentOdometer ?? this.currentOdometer,
    registeredAt: registeredAt ?? this.registeredAt,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      model: data.model.present ? data.model.value : this.model,
      trim: data.trim.present ? data.trim.value : this.trim,
      year: data.year.present ? data.year.value : this.year,
      currentOdometer: data.currentOdometer.present
          ? data.currentOdometer.value
          : this.currentOdometer,
      registeredAt: data.registeredAt.present
          ? data.registeredAt.value
          : this.registeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('model: $model, ')
          ..write('trim: $trim, ')
          ..write('year: $year, ')
          ..write('currentOdometer: $currentOdometer, ')
          ..write('registeredAt: $registeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, model, trim, year, currentOdometer, registeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.name == this.name &&
          other.model == this.model &&
          other.trim == this.trim &&
          other.year == this.year &&
          other.currentOdometer == this.currentOdometer &&
          other.registeredAt == this.registeredAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> model;
  final Value<String?> trim;
  final Value<int?> year;
  final Value<int> currentOdometer;
  final Value<DateTime> registeredAt;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.model = const Value.absent(),
    this.trim = const Value.absent(),
    this.year = const Value.absent(),
    this.currentOdometer = const Value.absent(),
    this.registeredAt = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String model,
    this.trim = const Value.absent(),
    this.year = const Value.absent(),
    this.currentOdometer = const Value.absent(),
    this.registeredAt = const Value.absent(),
  }) : name = Value(name),
       model = Value(model);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? model,
    Expression<String>? trim,
    Expression<int>? year,
    Expression<int>? currentOdometer,
    Expression<DateTime>? registeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (model != null) 'model': model,
      if (trim != null) 'trim': trim,
      if (year != null) 'year': year,
      if (currentOdometer != null) 'current_odometer': currentOdometer,
      if (registeredAt != null) 'registered_at': registeredAt,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? model,
    Value<String?>? trim,
    Value<int?>? year,
    Value<int>? currentOdometer,
    Value<DateTime>? registeredAt,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      trim: trim ?? this.trim,
      year: year ?? this.year,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      registeredAt: registeredAt ?? this.registeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (trim.present) {
      map['trim'] = Variable<String>(trim.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (currentOdometer.present) {
      map['current_odometer'] = Variable<int>(currentOdometer.value);
    }
    if (registeredAt.present) {
      map['registered_at'] = Variable<DateTime>(registeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('model: $model, ')
          ..write('trim: $trim, ')
          ..write('year: $year, ')
          ..write('currentOdometer: $currentOdometer, ')
          ..write('registeredAt: $registeredAt')
          ..write(')'))
        .toString();
  }
}

class $ItemSpecsTable extends ItemSpecs
    with TableInfo<$ItemSpecsTable, ItemSpec> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemSpecsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleKoMeta = const VerificationMeta('subtitleKo');
  @override
  late final GeneratedColumn<String> subtitleKo = GeneratedColumn<String>(
    'subtitle_ko',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalKmMeta = const VerificationMeta(
    'intervalKm',
  );
  @override
  late final GeneratedColumn<int> intervalKm = GeneratedColumn<int>(
    'interval_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalMonthsMeta = const VerificationMeta(
    'intervalMonths',
  );
  @override
  late final GeneratedColumn<int> intervalMonths = GeneratedColumn<int>(
    'interval_months',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _severeIntervalKmMeta = const VerificationMeta(
    'severeIntervalKm',
  );
  @override
  late final GeneratedColumn<int> severeIntervalKm = GeneratedColumn<int>(
    'severe_interval_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urgencyThresholdKmMeta = const VerificationMeta('urgencyThresholdKm');
  @override
  late final GeneratedColumn<int> urgencyThresholdKm = GeneratedColumn<int>(
    'urgency_threshold_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urgencyThresholdDaysMeta = const VerificationMeta('urgencyThresholdDays');
  @override
  late final GeneratedColumn<int> urgencyThresholdDays = GeneratedColumn<int>(
    'urgency_threshold_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _behaviorMeta = const VerificationMeta(
    'behavior',
  );
  @override
  late final GeneratedColumn<String> behavior = GeneratedColumn<String>(
    'behavior',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReplacedOdometerMeta =
      const VerificationMeta('lastReplacedOdometer');
  @override
  late final GeneratedColumn<int> lastReplacedOdometer = GeneratedColumn<int>(
    'last_replaced_odometer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReplacedDateMeta = const VerificationMeta(
    'lastReplacedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastReplacedDate =
      GeneratedColumn<DateTime>(
        'last_replaced_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta(
    'isHidden',
  );
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    key,
    name,
    subtitleKo,
    category,
    intervalKm,
    intervalMonths,
    severeIntervalKm,
    urgencyThresholdKm,
    urgencyThresholdDays,
    note,
    behavior,
    lastReplacedOdometer,
    lastReplacedDate,
    isHidden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_specs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemSpec> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('interval_km')) {
      context.handle(
        _intervalKmMeta,
        intervalKm.isAcceptableOrUnknown(data['interval_km']!, _intervalKmMeta),
      );
    }
    if (data.containsKey('interval_months')) {
      context.handle(
        _intervalMonthsMeta,
        intervalMonths.isAcceptableOrUnknown(
          data['interval_months']!,
          _intervalMonthsMeta,
        ),
      );
    }
    if (data.containsKey('severe_interval_km')) {
      context.handle(
        _severeIntervalKmMeta,
        severeIntervalKm.isAcceptableOrUnknown(
          data['severe_interval_km']!,
          _severeIntervalKmMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('behavior')) {
      context.handle(
        _behaviorMeta,
        behavior.isAcceptableOrUnknown(data['behavior']!, _behaviorMeta),
      );
    }
    if (data.containsKey('last_replaced_odometer')) {
      context.handle(
        _lastReplacedOdometerMeta,
        lastReplacedOdometer.isAcceptableOrUnknown(
          data['last_replaced_odometer']!,
          _lastReplacedOdometerMeta,
        ),
      );
    }
    if (data.containsKey('last_replaced_date')) {
      context.handle(
        _lastReplacedDateMeta,
        lastReplacedDate.isAcceptableOrUnknown(
          data['last_replaced_date']!,
          _lastReplacedDateMeta,
        ),
      );
    }
    if (data.containsKey('subtitle_ko')) {
      context.handle(
        _subtitleKoMeta,
        subtitleKo.isAcceptableOrUnknown(data['subtitle_ko']!, _subtitleKoMeta),
      );
    }
    if (data.containsKey('urgency_threshold_km')) {
      context.handle(
        _urgencyThresholdKmMeta,
        urgencyThresholdKm.isAcceptableOrUnknown(
          data['urgency_threshold_km']!,
          _urgencyThresholdKmMeta,
        ),
      );
    }
    if (data.containsKey('urgency_threshold_days')) {
      context.handle(
        _urgencyThresholdDaysMeta,
        urgencyThresholdDays.isAcceptableOrUnknown(
          data['urgency_threshold_days']!,
          _urgencyThresholdDaysMeta,
        ),
      );
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemSpec map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemSpec(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      subtitleKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle_ko'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      intervalKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_km'],
      ),
      intervalMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_months'],
      ),
      severeIntervalKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severe_interval_km'],
      ),
      urgencyThresholdKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urgency_threshold_km'],
      ),
      urgencyThresholdDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urgency_threshold_days'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      behavior: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}behavior'],
      ),
      lastReplacedOdometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_replaced_odometer'],
      ),
      lastReplacedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_replaced_date'],
      ),
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
    );
  }

  @override
  $ItemSpecsTable createAlias(String alias) {
    return $ItemSpecsTable(attachedDatabase, alias);
  }
}

class ItemSpec extends DataClass implements Insertable<ItemSpec> {
  final int id;
  final int vehicleId;
  final String key;
  final String name;
  final String? subtitleKo;
  final String category;
  final int? intervalKm;
  final int? intervalMonths;
  final int? severeIntervalKm;
  final int? urgencyThresholdKm;
  final int? urgencyThresholdDays;
  final String? note;
  final String? behavior;
  final int? lastReplacedOdometer;
  final DateTime? lastReplacedDate;
  final bool isHidden;
  const ItemSpec({
    required this.id,
    required this.vehicleId,
    required this.key,
    required this.name,
    this.subtitleKo,
    required this.category,
    this.intervalKm,
    this.intervalMonths,
    this.severeIntervalKm,
    this.urgencyThresholdKm,
    this.urgencyThresholdDays,
    this.note,
    this.behavior,
    this.lastReplacedOdometer,
    this.lastReplacedDate,
    required this.isHidden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['key'] = Variable<String>(key);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || subtitleKo != null) {
      map['subtitle_ko'] = Variable<String>(subtitleKo);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || intervalKm != null) {
      map['interval_km'] = Variable<int>(intervalKm);
    }
    if (!nullToAbsent || intervalMonths != null) {
      map['interval_months'] = Variable<int>(intervalMonths);
    }
    if (!nullToAbsent || severeIntervalKm != null) {
      map['severe_interval_km'] = Variable<int>(severeIntervalKm);
    }
    if (!nullToAbsent || urgencyThresholdKm != null) {
      map['urgency_threshold_km'] = Variable<int>(urgencyThresholdKm);
    }
    if (!nullToAbsent || urgencyThresholdDays != null) {
      map['urgency_threshold_days'] = Variable<int>(urgencyThresholdDays);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || behavior != null) {
      map['behavior'] = Variable<String>(behavior);
    }
    if (!nullToAbsent || lastReplacedOdometer != null) {
      map['last_replaced_odometer'] = Variable<int>(lastReplacedOdometer);
    }
    if (!nullToAbsent || lastReplacedDate != null) {
      map['last_replaced_date'] = Variable<DateTime>(lastReplacedDate);
    }
    map['is_hidden'] = Variable<bool>(isHidden);
    return map;
  }

  ItemSpecsCompanion toCompanion(bool nullToAbsent) {
    return ItemSpecsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      key: Value(key),
      name: Value(name),
      subtitleKo: subtitleKo == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitleKo),
      category: Value(category),
      intervalKm: intervalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalKm),
      intervalMonths: intervalMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalMonths),
      severeIntervalKm: severeIntervalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(severeIntervalKm),
      urgencyThresholdKm: urgencyThresholdKm == null && nullToAbsent
          ? const Value.absent()
          : Value(urgencyThresholdKm),
      urgencyThresholdDays: urgencyThresholdDays == null && nullToAbsent
          ? const Value.absent()
          : Value(urgencyThresholdDays),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      behavior: behavior == null && nullToAbsent
          ? const Value.absent()
          : Value(behavior),
      lastReplacedOdometer: lastReplacedOdometer == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReplacedOdometer),
      lastReplacedDate: lastReplacedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReplacedDate),
      isHidden: Value(isHidden),
    );
  }

  factory ItemSpec.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemSpec(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      key: serializer.fromJson<String>(json['key']),
      name: serializer.fromJson<String>(json['name']),
      subtitleKo: serializer.fromJson<String?>(json['subtitleKo']),
      category: serializer.fromJson<String>(json['category']),
      intervalKm: serializer.fromJson<int?>(json['intervalKm']),
      intervalMonths: serializer.fromJson<int?>(json['intervalMonths']),
      severeIntervalKm: serializer.fromJson<int?>(json['severeIntervalKm']),
      urgencyThresholdKm: serializer.fromJson<int?>(json['urgencyThresholdKm']),
      urgencyThresholdDays: serializer.fromJson<int?>(json['urgencyThresholdDays']),
      note: serializer.fromJson<String?>(json['note']),
      behavior: serializer.fromJson<String?>(json['behavior']),
      lastReplacedOdometer: serializer.fromJson<int?>(
        json['lastReplacedOdometer'],
      ),
      lastReplacedDate: serializer.fromJson<DateTime?>(
        json['lastReplacedDate'],
      ),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'key': serializer.toJson<String>(key),
      'name': serializer.toJson<String>(name),
      'subtitleKo': serializer.toJson<String?>(subtitleKo),
      'category': serializer.toJson<String>(category),
      'intervalKm': serializer.toJson<int?>(intervalKm),
      'intervalMonths': serializer.toJson<int?>(intervalMonths),
      'severeIntervalKm': serializer.toJson<int?>(severeIntervalKm),
      'urgencyThresholdKm': serializer.toJson<int?>(urgencyThresholdKm),
      'urgencyThresholdDays': serializer.toJson<int?>(urgencyThresholdDays),
      'note': serializer.toJson<String?>(note),
      'behavior': serializer.toJson<String?>(behavior),
      'lastReplacedOdometer': serializer.toJson<int?>(lastReplacedOdometer),
      'lastReplacedDate': serializer.toJson<DateTime?>(lastReplacedDate),
      'isHidden': serializer.toJson<bool>(isHidden),
    };
  }

  ItemSpec copyWith({
    int? id,
    int? vehicleId,
    String? key,
    String? name,
    Value<String?> subtitleKo = const Value.absent(),
    String? category,
    Value<int?> intervalKm = const Value.absent(),
    Value<int?> intervalMonths = const Value.absent(),
    Value<int?> severeIntervalKm = const Value.absent(),
    Value<int?> urgencyThresholdKm = const Value.absent(),
    Value<int?> urgencyThresholdDays = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> behavior = const Value.absent(),
    Value<int?> lastReplacedOdometer = const Value.absent(),
    Value<DateTime?> lastReplacedDate = const Value.absent(),
    bool? isHidden,
  }) => ItemSpec(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    key: key ?? this.key,
    name: name ?? this.name,
    subtitleKo: subtitleKo.present ? subtitleKo.value : this.subtitleKo,
    category: category ?? this.category,
    intervalKm: intervalKm.present ? intervalKm.value : this.intervalKm,
    intervalMonths: intervalMonths.present
        ? intervalMonths.value
        : this.intervalMonths,
    severeIntervalKm: severeIntervalKm.present
        ? severeIntervalKm.value
        : this.severeIntervalKm,
    urgencyThresholdKm: urgencyThresholdKm.present
        ? urgencyThresholdKm.value
        : this.urgencyThresholdKm,
    urgencyThresholdDays: urgencyThresholdDays.present
        ? urgencyThresholdDays.value
        : this.urgencyThresholdDays,
    note: note.present ? note.value : this.note,
    behavior: behavior.present ? behavior.value : this.behavior,
    lastReplacedOdometer: lastReplacedOdometer.present
        ? lastReplacedOdometer.value
        : this.lastReplacedOdometer,
    lastReplacedDate: lastReplacedDate.present
        ? lastReplacedDate.value
        : this.lastReplacedDate,
    isHidden: isHidden ?? this.isHidden,
  );
  ItemSpec copyWithCompanion(ItemSpecsCompanion data) {
    return ItemSpec(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      key: data.key.present ? data.key.value : this.key,
      name: data.name.present ? data.name.value : this.name,
      subtitleKo: data.subtitleKo.present ? data.subtitleKo.value : this.subtitleKo,
      category: data.category.present ? data.category.value : this.category,
      intervalKm: data.intervalKm.present
          ? data.intervalKm.value
          : this.intervalKm,
      intervalMonths: data.intervalMonths.present
          ? data.intervalMonths.value
          : this.intervalMonths,
      severeIntervalKm: data.severeIntervalKm.present
          ? data.severeIntervalKm.value
          : this.severeIntervalKm,
      urgencyThresholdKm: data.urgencyThresholdKm.present
          ? data.urgencyThresholdKm.value
          : this.urgencyThresholdKm,
      urgencyThresholdDays: data.urgencyThresholdDays.present
          ? data.urgencyThresholdDays.value
          : this.urgencyThresholdDays,
      note: data.note.present ? data.note.value : this.note,
      behavior: data.behavior.present ? data.behavior.value : this.behavior,
      lastReplacedOdometer: data.lastReplacedOdometer.present
          ? data.lastReplacedOdometer.value
          : this.lastReplacedOdometer,
      lastReplacedDate: data.lastReplacedDate.present
          ? data.lastReplacedDate.value
          : this.lastReplacedDate,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemSpec(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('subtitleKo: $subtitleKo, ')
          ..write('category: $category, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('severeIntervalKm: $severeIntervalKm, ')
          ..write('urgencyThresholdKm: $urgencyThresholdKm, ')
          ..write('urgencyThresholdDays: $urgencyThresholdDays, ')
          ..write('note: $note, ')
          ..write('behavior: $behavior, ')
          ..write('lastReplacedOdometer: $lastReplacedOdometer, ')
          ..write('lastReplacedDate: $lastReplacedDate, ')
          ..write('isHidden: $isHidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    vehicleId,
    key,
    name,
    subtitleKo,
    category,
    intervalKm,
    intervalMonths,
    severeIntervalKm,
    urgencyThresholdKm,
    urgencyThresholdDays,
    note,
    behavior,
    lastReplacedOdometer,
    lastReplacedDate,
    isHidden,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemSpec &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.key == this.key &&
          other.name == this.name &&
          other.subtitleKo == this.subtitleKo &&
          other.category == this.category &&
          other.intervalKm == this.intervalKm &&
          other.intervalMonths == this.intervalMonths &&
          other.severeIntervalKm == this.severeIntervalKm &&
          other.urgencyThresholdKm == this.urgencyThresholdKm &&
          other.urgencyThresholdDays == this.urgencyThresholdDays &&
          other.note == this.note &&
          other.behavior == this.behavior &&
          other.lastReplacedOdometer == this.lastReplacedOdometer &&
          other.lastReplacedDate == this.lastReplacedDate &&
          other.isHidden == this.isHidden);
}

class ItemSpecsCompanion extends UpdateCompanion<ItemSpec> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> key;
  final Value<String> name;
  final Value<String?> subtitleKo;
  final Value<String> category;
  final Value<int?> intervalKm;
  final Value<int?> intervalMonths;
  final Value<int?> severeIntervalKm;
  final Value<int?> urgencyThresholdKm;
  final Value<int?> urgencyThresholdDays;
  final Value<String?> note;
  final Value<String?> behavior;
  final Value<int?> lastReplacedOdometer;
  final Value<DateTime?> lastReplacedDate;
  final Value<bool> isHidden;
  const ItemSpecsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.key = const Value.absent(),
    this.name = const Value.absent(),
    this.subtitleKo = const Value.absent(),
    this.category = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.severeIntervalKm = const Value.absent(),
    this.urgencyThresholdKm = const Value.absent(),
    this.urgencyThresholdDays = const Value.absent(),
    this.note = const Value.absent(),
    this.behavior = const Value.absent(),
    this.lastReplacedOdometer = const Value.absent(),
    this.lastReplacedDate = const Value.absent(),
    this.isHidden = const Value.absent(),
  });
  ItemSpecsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String key,
    required String name,
    this.subtitleKo = const Value.absent(),
    required String category,
    this.intervalKm = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.severeIntervalKm = const Value.absent(),
    this.urgencyThresholdKm = const Value.absent(),
    this.urgencyThresholdDays = const Value.absent(),
    this.note = const Value.absent(),
    this.behavior = const Value.absent(),
    this.lastReplacedOdometer = const Value.absent(),
    this.lastReplacedDate = const Value.absent(),
    this.isHidden = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       key = Value(key),
       name = Value(name),
       category = Value(category);
  static Insertable<ItemSpec> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? key,
    Expression<String>? name,
    Expression<String>? subtitleKo,
    Expression<String>? category,
    Expression<int>? intervalKm,
    Expression<int>? intervalMonths,
    Expression<int>? severeIntervalKm,
    Expression<int>? urgencyThresholdKm,
    Expression<int>? urgencyThresholdDays,
    Expression<String>? note,
    Expression<String>? behavior,
    Expression<int>? lastReplacedOdometer,
    Expression<DateTime>? lastReplacedDate,
    Expression<bool>? isHidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (key != null) 'key': key,
      if (name != null) 'name': name,
      if (subtitleKo != null) 'subtitle_ko': subtitleKo,
      if (category != null) 'category': category,
      if (intervalKm != null) 'interval_km': intervalKm,
      if (intervalMonths != null) 'interval_months': intervalMonths,
      if (severeIntervalKm != null) 'severe_interval_km': severeIntervalKm,
      if (urgencyThresholdKm != null) 'urgency_threshold_km': urgencyThresholdKm,
      if (urgencyThresholdDays != null) 'urgency_threshold_days': urgencyThresholdDays,
      if (note != null) 'note': note,
      if (behavior != null) 'behavior': behavior,
      if (lastReplacedOdometer != null)
        'last_replaced_odometer': lastReplacedOdometer,
      if (lastReplacedDate != null) 'last_replaced_date': lastReplacedDate,
      if (isHidden != null) 'is_hidden': isHidden,
    });
  }

  ItemSpecsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? key,
    Value<String>? name,
    Value<String?>? subtitleKo,
    Value<String>? category,
    Value<int?>? intervalKm,
    Value<int?>? intervalMonths,
    Value<int?>? severeIntervalKm,
    Value<int?>? urgencyThresholdKm,
    Value<int?>? urgencyThresholdDays,
    Value<String?>? note,
    Value<String?>? behavior,
    Value<int?>? lastReplacedOdometer,
    Value<DateTime?>? lastReplacedDate,
    Value<bool>? isHidden,
  }) {
    return ItemSpecsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      key: key ?? this.key,
      name: name ?? this.name,
      subtitleKo: subtitleKo ?? this.subtitleKo,
      category: category ?? this.category,
      intervalKm: intervalKm ?? this.intervalKm,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      severeIntervalKm: severeIntervalKm ?? this.severeIntervalKm,
      urgencyThresholdKm: urgencyThresholdKm ?? this.urgencyThresholdKm,
      urgencyThresholdDays: urgencyThresholdDays ?? this.urgencyThresholdDays,
      note: note ?? this.note,
      behavior: behavior ?? this.behavior,
      lastReplacedOdometer: lastReplacedOdometer ?? this.lastReplacedOdometer,
      lastReplacedDate: lastReplacedDate ?? this.lastReplacedDate,
      isHidden: isHidden ?? this.isHidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (subtitleKo.present) {
      map['subtitle_ko'] = Variable<String>(subtitleKo.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (intervalKm.present) {
      map['interval_km'] = Variable<int>(intervalKm.value);
    }
    if (intervalMonths.present) {
      map['interval_months'] = Variable<int>(intervalMonths.value);
    }
    if (severeIntervalKm.present) {
      map['severe_interval_km'] = Variable<int>(severeIntervalKm.value);
    }
    if (urgencyThresholdKm.present) {
      map['urgency_threshold_km'] = Variable<int>(urgencyThresholdKm.value);
    }
    if (urgencyThresholdDays.present) {
      map['urgency_threshold_days'] = Variable<int>(urgencyThresholdDays.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (behavior.present) {
      map['behavior'] = Variable<String>(behavior.value);
    }
    if (lastReplacedOdometer.present) {
      map['last_replaced_odometer'] = Variable<int>(lastReplacedOdometer.value);
    }
    if (lastReplacedDate.present) {
      map['last_replaced_date'] = Variable<DateTime>(lastReplacedDate.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemSpecsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('key: $key, ')
          ..write('name: $name, ')
          ..write('subtitleKo: $subtitleKo, ')
          ..write('category: $category, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('severeIntervalKm: $severeIntervalKm, ')
          ..write('urgencyThresholdKm: $urgencyThresholdKm, ')
          ..write('urgencyThresholdDays: $urgencyThresholdDays, ')
          ..write('note: $note, ')
          ..write('behavior: $behavior, ')
          ..write('lastReplacedOdometer: $lastReplacedOdometer, ')
          ..write('lastReplacedDate: $lastReplacedDate, ')
          ..write('isHidden: $isHidden')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _rawMessageMeta = const VerificationMeta(
    'rawMessage',
  );
  @override
  late final GeneratedColumn<String> rawMessage = GeneratedColumn<String>(
    'raw_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    category,
    title,
    place,
    date,
    amount,
    source,
    rawMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('raw_message')) {
      context.handle(
        _rawMessageMeta,
        rawMessage.isAcceptableOrUnknown(data['raw_message']!, _rawMessageMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      rawMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int vehicleId;
  final String category;
  final String title;
  final String? place;
  final DateTime date;
  final int amount;
  final String source;
  final String? rawMessage;
  final DateTime createdAt;
  const Expense({
    required this.id,
    required this.vehicleId,
    required this.category,
    required this.title,
    this.place,
    required this.date,
    required this.amount,
    required this.source,
    this.rawMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<int>(amount);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || rawMessage != null) {
      map['raw_message'] = Variable<String>(rawMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      category: Value(category),
      title: Value(title),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      date: Value(date),
      amount: Value(amount),
      source: Value(source),
      rawMessage: rawMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(rawMessage),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      place: serializer.fromJson<String?>(json['place']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<int>(json['amount']),
      source: serializer.fromJson<String>(json['source']),
      rawMessage: serializer.fromJson<String?>(json['rawMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'place': serializer.toJson<String?>(place),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<int>(amount),
      'source': serializer.toJson<String>(source),
      'rawMessage': serializer.toJson<String?>(rawMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith({
    int? id,
    int? vehicleId,
    String? category,
    String? title,
    Value<String?> place = const Value.absent(),
    DateTime? date,
    int? amount,
    String? source,
    Value<String?> rawMessage = const Value.absent(),
    DateTime? createdAt,
  }) => Expense(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    category: category ?? this.category,
    title: title ?? this.title,
    place: place.present ? place.value : this.place,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    source: source ?? this.source,
    rawMessage: rawMessage.present ? rawMessage.value : this.rawMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      place: data.place.present ? data.place.value : this.place,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      source: data.source.present ? data.source.value : this.source,
      rawMessage: data.rawMessage.present
          ? data.rawMessage.value
          : this.rawMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('place: $place, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('rawMessage: $rawMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    category,
    title,
    place,
    date,
    amount,
    source,
    rawMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.category == this.category &&
          other.title == this.title &&
          other.place == this.place &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.source == this.source &&
          other.rawMessage == this.rawMessage &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> category;
  final Value<String> title;
  final Value<String?> place;
  final Value<DateTime> date;
  final Value<int> amount;
  final Value<String> source;
  final Value<String?> rawMessage;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.place = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.source = const Value.absent(),
    this.rawMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String category,
    required String title,
    this.place = const Value.absent(),
    required DateTime date,
    required int amount,
    this.source = const Value.absent(),
    this.rawMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       category = Value(category),
       title = Value(title),
       date = Value(date),
       amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? place,
    Expression<DateTime>? date,
    Expression<int>? amount,
    Expression<String>? source,
    Expression<String>? rawMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (place != null) 'place': place,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (source != null) 'source': source,
      if (rawMessage != null) 'raw_message': rawMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? category,
    Value<String>? title,
    Value<String?>? place,
    Value<DateTime>? date,
    Value<int>? amount,
    Value<String>? source,
    Value<String?>? rawMessage,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      category: category ?? this.category,
      title: title ?? this.title,
      place: place ?? this.place,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      rawMessage: rawMessage ?? this.rawMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rawMessage.present) {
      map['raw_message'] = Variable<String>(rawMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('place: $place, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('rawMessage: $rawMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceRecordsTable extends MaintenanceRecords
    with TableInfo<$MaintenanceRecordsTable, MaintenanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _itemSpecIdMeta = const VerificationMeta(
    'itemSpecId',
  );
  @override
  late final GeneratedColumn<int> itemSpecId = GeneratedColumn<int>(
    'item_spec_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES item_specs (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<int> odometer = GeneratedColumn<int>(
    'odometer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expenseIdMeta = const VerificationMeta(
    'expenseId',
  );
  @override
  late final GeneratedColumn<int> expenseId = GeneratedColumn<int>(
    'expense_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expenses (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    itemSpecId,
    type,
    date,
    odometer,
    place,
    memo,
    expenseId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('item_spec_id')) {
      context.handle(
        _itemSpecIdMeta,
        itemSpecId.isAcceptableOrUnknown(
          data['item_spec_id']!,
          _itemSpecIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerMeta);
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('expense_id')) {
      context.handle(
        _expenseIdMeta,
        expenseId.isAcceptableOrUnknown(data['expense_id']!, _expenseIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      itemSpecId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_spec_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer'],
      )!,
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      expenseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expense_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MaintenanceRecordsTable createAlias(String alias) {
    return $MaintenanceRecordsTable(attachedDatabase, alias);
  }
}

class MaintenanceRecord extends DataClass
    implements Insertable<MaintenanceRecord> {
  final int id;
  final int vehicleId;
  final int? itemSpecId;
  final String type;
  final DateTime date;
  final int odometer;
  final String? place;
  final String? memo;
  final int? expenseId;
  final DateTime createdAt;
  const MaintenanceRecord({
    required this.id,
    required this.vehicleId,
    this.itemSpecId,
    required this.type,
    required this.date,
    required this.odometer,
    this.place,
    this.memo,
    this.expenseId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    if (!nullToAbsent || itemSpecId != null) {
      map['item_spec_id'] = Variable<int>(itemSpecId);
    }
    map['type'] = Variable<String>(type);
    map['date'] = Variable<DateTime>(date);
    map['odometer'] = Variable<int>(odometer);
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || expenseId != null) {
      map['expense_id'] = Variable<int>(expenseId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MaintenanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceRecordsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      itemSpecId: itemSpecId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemSpecId),
      type: Value(type),
      date: Value(date),
      odometer: Value(odometer),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      expenseId: expenseId == null && nullToAbsent
          ? const Value.absent()
          : Value(expenseId),
      createdAt: Value(createdAt),
    );
  }

  factory MaintenanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceRecord(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      itemSpecId: serializer.fromJson<int?>(json['itemSpecId']),
      type: serializer.fromJson<String>(json['type']),
      date: serializer.fromJson<DateTime>(json['date']),
      odometer: serializer.fromJson<int>(json['odometer']),
      place: serializer.fromJson<String?>(json['place']),
      memo: serializer.fromJson<String?>(json['memo']),
      expenseId: serializer.fromJson<int?>(json['expenseId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'itemSpecId': serializer.toJson<int?>(itemSpecId),
      'type': serializer.toJson<String>(type),
      'date': serializer.toJson<DateTime>(date),
      'odometer': serializer.toJson<int>(odometer),
      'place': serializer.toJson<String?>(place),
      'memo': serializer.toJson<String?>(memo),
      'expenseId': serializer.toJson<int?>(expenseId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MaintenanceRecord copyWith({
    int? id,
    int? vehicleId,
    Value<int?> itemSpecId = const Value.absent(),
    String? type,
    DateTime? date,
    int? odometer,
    Value<String?> place = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<int?> expenseId = const Value.absent(),
    DateTime? createdAt,
  }) => MaintenanceRecord(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    itemSpecId: itemSpecId.present ? itemSpecId.value : this.itemSpecId,
    type: type ?? this.type,
    date: date ?? this.date,
    odometer: odometer ?? this.odometer,
    place: place.present ? place.value : this.place,
    memo: memo.present ? memo.value : this.memo,
    expenseId: expenseId.present ? expenseId.value : this.expenseId,
    createdAt: createdAt ?? this.createdAt,
  );
  MaintenanceRecord copyWithCompanion(MaintenanceRecordsCompanion data) {
    return MaintenanceRecord(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      itemSpecId: data.itemSpecId.present
          ? data.itemSpecId.value
          : this.itemSpecId,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      place: data.place.present ? data.place.value : this.place,
      memo: data.memo.present ? data.memo.value : this.memo,
      expenseId: data.expenseId.present ? data.expenseId.value : this.expenseId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecord(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('itemSpecId: $itemSpecId, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('place: $place, ')
          ..write('memo: $memo, ')
          ..write('expenseId: $expenseId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    itemSpecId,
    type,
    date,
    odometer,
    place,
    memo,
    expenseId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceRecord &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.itemSpecId == this.itemSpecId &&
          other.type == this.type &&
          other.date == this.date &&
          other.odometer == this.odometer &&
          other.place == this.place &&
          other.memo == this.memo &&
          other.expenseId == this.expenseId &&
          other.createdAt == this.createdAt);
}

class MaintenanceRecordsCompanion extends UpdateCompanion<MaintenanceRecord> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<int?> itemSpecId;
  final Value<String> type;
  final Value<DateTime> date;
  final Value<int> odometer;
  final Value<String?> place;
  final Value<String?> memo;
  final Value<int?> expenseId;
  final Value<DateTime> createdAt;
  const MaintenanceRecordsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.itemSpecId = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.odometer = const Value.absent(),
    this.place = const Value.absent(),
    this.memo = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MaintenanceRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    this.itemSpecId = const Value.absent(),
    required String type,
    required DateTime date,
    required int odometer,
    this.place = const Value.absent(),
    this.memo = const Value.absent(),
    this.expenseId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       type = Value(type),
       date = Value(date),
       odometer = Value(odometer);
  static Insertable<MaintenanceRecord> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<int>? itemSpecId,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<int>? odometer,
    Expression<String>? place,
    Expression<String>? memo,
    Expression<int>? expenseId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (itemSpecId != null) 'item_spec_id': itemSpecId,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (odometer != null) 'odometer': odometer,
      if (place != null) 'place': place,
      if (memo != null) 'memo': memo,
      if (expenseId != null) 'expense_id': expenseId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MaintenanceRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<int?>? itemSpecId,
    Value<String>? type,
    Value<DateTime>? date,
    Value<int>? odometer,
    Value<String?>? place,
    Value<String?>? memo,
    Value<int?>? expenseId,
    Value<DateTime>? createdAt,
  }) {
    return MaintenanceRecordsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      itemSpecId: itemSpecId ?? this.itemSpecId,
      type: type ?? this.type,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      place: place ?? this.place,
      memo: memo ?? this.memo,
      expenseId: expenseId ?? this.expenseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (itemSpecId.present) {
      map['item_spec_id'] = Variable<int>(itemSpecId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<int>(odometer.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (expenseId.present) {
      map['expense_id'] = Variable<int>(expenseId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('itemSpecId: $itemSpecId, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('place: $place, ')
          ..write('memo: $memo, ')
          ..write('expenseId: $expenseId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $ItemSpecsTable itemSpecs = $ItemSpecsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $MaintenanceRecordsTable maintenanceRecords =
      $MaintenanceRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    itemSpecs,
    expenses,
    maintenanceRecords,
  ];
}

typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      required String name,
      required String model,
      Value<String?> trim,
      Value<int?> year,
      Value<int> currentOdometer,
      Value<DateTime> registeredAt,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> model,
      Value<String?> trim,
      Value<int?> year,
      Value<int> currentOdometer,
      Value<DateTime> registeredAt,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemSpecsTable, List<ItemSpec>>
  _itemSpecsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.itemSpecs,
    aliasName: $_aliasNameGenerator(db.vehicles.id, db.itemSpecs.vehicleId),
  );

  $$ItemSpecsTableProcessedTableManager get itemSpecsRefs {
    final manager = $$ItemSpecsTableTableManager(
      $_db,
      $_db.itemSpecs,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemSpecsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(db.vehicles.id, db.expenses.vehicleId),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaintenanceRecordsTable, List<MaintenanceRecord>>
  _maintenanceRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceRecords,
        aliasName: $_aliasNameGenerator(
          db.vehicles.id,
          db.maintenanceRecords.vehicleId,
        ),
      );

  $$MaintenanceRecordsTableProcessedTableManager get maintenanceRecordsRefs {
    final manager = $$MaintenanceRecordsTableTableManager(
      $_db,
      $_db.maintenanceRecords,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registeredAt => $composableBuilder(
    column: $table.registeredAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemSpecsRefs(
    Expression<bool> Function($$ItemSpecsTableFilterComposer f) f,
  ) {
    final $$ItemSpecsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemSpecs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemSpecsTableFilterComposer(
            $db: $db,
            $table: $db.itemSpecs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenanceRecordsRefs(
    Expression<bool> Function($$MaintenanceRecordsTableFilterComposer f) f,
  ) {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceRecords,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trim => $composableBuilder(
    column: $table.trim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registeredAt => $composableBuilder(
    column: $table.registeredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get trim =>
      $composableBuilder(column: $table.trim, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get currentOdometer => $composableBuilder(
    column: $table.currentOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registeredAt => $composableBuilder(
    column: $table.registeredAt,
    builder: (column) => column,
  );

  Expression<T> itemSpecsRefs<T extends Object>(
    Expression<T> Function($$ItemSpecsTableAnnotationComposer a) f,
  ) {
    final $$ItemSpecsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemSpecs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemSpecsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemSpecs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> maintenanceRecordsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceRecords,
          getReferencedColumn: (t) => t.vehicleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({
            bool itemSpecsRefs,
            bool expensesRefs,
            bool maintenanceRecordsRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String?> trim = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int> currentOdometer = const Value.absent(),
                Value<DateTime> registeredAt = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                model: model,
                trim: trim,
                year: year,
                currentOdometer: currentOdometer,
                registeredAt: registeredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String model,
                Value<String?> trim = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int> currentOdometer = const Value.absent(),
                Value<DateTime> registeredAt = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                model: model,
                trim: trim,
                year: year,
                currentOdometer: currentOdometer,
                registeredAt: registeredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                itemSpecsRefs = false,
                expensesRefs = false,
                maintenanceRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemSpecsRefs) db.itemSpecs,
                    if (expensesRefs) db.expenses,
                    if (maintenanceRecordsRefs) db.maintenanceRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemSpecsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          ItemSpec
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._itemSpecsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).itemSpecsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (maintenanceRecordsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          MaintenanceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({
        bool itemSpecsRefs,
        bool expensesRefs,
        bool maintenanceRecordsRefs,
      })
    >;
typedef $$ItemSpecsTableCreateCompanionBuilder =
    ItemSpecsCompanion Function({
      Value<int> id,
      required int vehicleId,
      required String key,
      required String name,
      Value<String?> subtitleKo,
      required String category,
      Value<int?> intervalKm,
      Value<int?> intervalMonths,
      Value<int?> severeIntervalKm,
      Value<int?> urgencyThresholdKm,
      Value<int?> urgencyThresholdDays,
      Value<String?> note,
      Value<String?> behavior,
      Value<int?> lastReplacedOdometer,
      Value<DateTime?> lastReplacedDate,
      Value<bool> isHidden,
    });
typedef $$ItemSpecsTableUpdateCompanionBuilder =
    ItemSpecsCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<String> key,
      Value<String> name,
      Value<String?> subtitleKo,
      Value<String> category,
      Value<int?> intervalKm,
      Value<int?> intervalMonths,
      Value<int?> severeIntervalKm,
      Value<int?> urgencyThresholdKm,
      Value<int?> urgencyThresholdDays,
      Value<String?> note,
      Value<String?> behavior,
      Value<int?> lastReplacedOdometer,
      Value<DateTime?> lastReplacedDate,
      Value<bool> isHidden,
    });

final class $$ItemSpecsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemSpecsTable, ItemSpec> {
  $$ItemSpecsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.itemSpecs.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MaintenanceRecordsTable, List<MaintenanceRecord>>
  _maintenanceRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceRecords,
        aliasName: $_aliasNameGenerator(
          db.itemSpecs.id,
          db.maintenanceRecords.itemSpecId,
        ),
      );

  $$MaintenanceRecordsTableProcessedTableManager get maintenanceRecordsRefs {
    final manager = $$MaintenanceRecordsTableTableManager(
      $_db,
      $_db.maintenanceRecords,
    ).filter((f) => f.itemSpecId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemSpecsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemSpecsTable> {
  $$ItemSpecsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMonths => $composableBuilder(
    column: $table.intervalMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severeIntervalKm => $composableBuilder(
    column: $table.severeIntervalKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get behavior => $composableBuilder(
    column: $table.behavior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReplacedOdometer => $composableBuilder(
    column: $table.lastReplacedOdometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReplacedDate => $composableBuilder(
    column: $table.lastReplacedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> maintenanceRecordsRefs(
    Expression<bool> Function($$MaintenanceRecordsTableFilterComposer f) f,
  ) {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceRecords,
      getReferencedColumn: (t) => t.itemSpecId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemSpecsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemSpecsTable> {
  $$ItemSpecsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMonths => $composableBuilder(
    column: $table.intervalMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severeIntervalKm => $composableBuilder(
    column: $table.severeIntervalKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get behavior => $composableBuilder(
    column: $table.behavior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReplacedOdometer => $composableBuilder(
    column: $table.lastReplacedOdometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReplacedDate => $composableBuilder(
    column: $table.lastReplacedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHidden => $composableBuilder(
    column: $table.isHidden,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemSpecsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemSpecsTable> {
  $$ItemSpecsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalMonths => $composableBuilder(
    column: $table.intervalMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get severeIntervalKm => $composableBuilder(
    column: $table.severeIntervalKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get behavior =>
      $composableBuilder(column: $table.behavior, builder: (column) => column);

  GeneratedColumn<int> get lastReplacedOdometer => $composableBuilder(
    column: $table.lastReplacedOdometer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReplacedDate => $composableBuilder(
    column: $table.lastReplacedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> maintenanceRecordsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceRecords,
          getReferencedColumn: (t) => t.itemSpecId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ItemSpecsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemSpecsTable,
          ItemSpec,
          $$ItemSpecsTableFilterComposer,
          $$ItemSpecsTableOrderingComposer,
          $$ItemSpecsTableAnnotationComposer,
          $$ItemSpecsTableCreateCompanionBuilder,
          $$ItemSpecsTableUpdateCompanionBuilder,
          (ItemSpec, $$ItemSpecsTableReferences),
          ItemSpec,
          PrefetchHooks Function({bool vehicleId, bool maintenanceRecordsRefs})
        > {
  $$ItemSpecsTableTableManager(_$AppDatabase db, $ItemSpecsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemSpecsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemSpecsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemSpecsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> subtitleKo = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int?> intervalKm = const Value.absent(),
                Value<int?> intervalMonths = const Value.absent(),
                Value<int?> severeIntervalKm = const Value.absent(),
                Value<int?> urgencyThresholdKm = const Value.absent(),
                Value<int?> urgencyThresholdDays = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> behavior = const Value.absent(),
                Value<int?> lastReplacedOdometer = const Value.absent(),
                Value<DateTime?> lastReplacedDate = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
              }) => ItemSpecsCompanion(
                id: id,
                vehicleId: vehicleId,
                key: key,
                name: name,
                subtitleKo: subtitleKo,
                category: category,
                intervalKm: intervalKm,
                intervalMonths: intervalMonths,
                severeIntervalKm: severeIntervalKm,
                urgencyThresholdKm: urgencyThresholdKm,
                urgencyThresholdDays: urgencyThresholdDays,
                note: note,
                behavior: behavior,
                lastReplacedOdometer: lastReplacedOdometer,
                lastReplacedDate: lastReplacedDate,
                isHidden: isHidden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String key,
                required String name,
                Value<String?> subtitleKo = const Value.absent(),
                required String category,
                Value<int?> intervalKm = const Value.absent(),
                Value<int?> intervalMonths = const Value.absent(),
                Value<int?> severeIntervalKm = const Value.absent(),
                Value<int?> urgencyThresholdKm = const Value.absent(),
                Value<int?> urgencyThresholdDays = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> behavior = const Value.absent(),
                Value<int?> lastReplacedOdometer = const Value.absent(),
                Value<DateTime?> lastReplacedDate = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
              }) => ItemSpecsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                key: key,
                name: name,
                subtitleKo: subtitleKo,
                category: category,
                intervalKm: intervalKm,
                intervalMonths: intervalMonths,
                severeIntervalKm: severeIntervalKm,
                urgencyThresholdKm: urgencyThresholdKm,
                urgencyThresholdDays: urgencyThresholdDays,
                note: note,
                behavior: behavior,
                lastReplacedOdometer: lastReplacedOdometer,
                lastReplacedDate: lastReplacedDate,
                isHidden: isHidden,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ItemSpecsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, maintenanceRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (maintenanceRecordsRefs) db.maintenanceRecords,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable: $$ItemSpecsTableReferences
                                        ._vehicleIdTable(db),
                                    referencedColumn: $$ItemSpecsTableReferences
                                        ._vehicleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (maintenanceRecordsRefs)
                        await $_getPrefetchedData<
                          ItemSpec,
                          $ItemSpecsTable,
                          MaintenanceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ItemSpecsTableReferences
                              ._maintenanceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemSpecsTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemSpecId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemSpecsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemSpecsTable,
      ItemSpec,
      $$ItemSpecsTableFilterComposer,
      $$ItemSpecsTableOrderingComposer,
      $$ItemSpecsTableAnnotationComposer,
      $$ItemSpecsTableCreateCompanionBuilder,
      $$ItemSpecsTableUpdateCompanionBuilder,
      (ItemSpec, $$ItemSpecsTableReferences),
      ItemSpec,
      PrefetchHooks Function({bool vehicleId, bool maintenanceRecordsRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required int vehicleId,
      required String category,
      required String title,
      Value<String?> place,
      required DateTime date,
      required int amount,
      Value<String> source,
      Value<String?> rawMessage,
      Value<DateTime> createdAt,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<String> category,
      Value<String> title,
      Value<String?> place,
      Value<DateTime> date,
      Value<int> amount,
      Value<String> source,
      Value<String?> rawMessage,
      Value<DateTime> createdAt,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) => db.vehicles
      .createAlias($_aliasNameGenerator(db.expenses.vehicleId, db.vehicles.id));

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MaintenanceRecordsTable, List<MaintenanceRecord>>
  _maintenanceRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceRecords,
        aliasName: $_aliasNameGenerator(
          db.expenses.id,
          db.maintenanceRecords.expenseId,
        ),
      );

  $$MaintenanceRecordsTableProcessedTableManager get maintenanceRecordsRefs {
    final manager = $$MaintenanceRecordsTableTableManager(
      $_db,
      $_db.maintenanceRecords,
    ).filter((f) => f.expenseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawMessage => $composableBuilder(
    column: $table.rawMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> maintenanceRecordsRefs(
    Expression<bool> Function($$MaintenanceRecordsTableFilterComposer f) f,
  ) {
    final $$MaintenanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceRecords,
      getReferencedColumn: (t) => t.expenseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawMessage => $composableBuilder(
    column: $table.rawMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get rawMessage => $composableBuilder(
    column: $table.rawMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> maintenanceRecordsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceRecords,
          getReferencedColumn: (t) => t.expenseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool vehicleId, bool maintenanceRecordsRefs})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> rawMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                vehicleId: vehicleId,
                category: category,
                title: title,
                place: place,
                date: date,
                amount: amount,
                source: source,
                rawMessage: rawMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String category,
                required String title,
                Value<String?> place = const Value.absent(),
                required DateTime date,
                required int amount,
                Value<String> source = const Value.absent(),
                Value<String?> rawMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                category: category,
                title: title,
                place: place,
                date: date,
                amount: amount,
                source: source,
                rawMessage: rawMessage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, maintenanceRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (maintenanceRecordsRefs) db.maintenanceRecords,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._vehicleIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._vehicleIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (maintenanceRecordsRefs)
                        await $_getPrefetchedData<
                          Expense,
                          $ExpensesTable,
                          MaintenanceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ExpensesTableReferences
                              ._maintenanceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExpensesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.expenseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool vehicleId, bool maintenanceRecordsRefs})
    >;
typedef $$MaintenanceRecordsTableCreateCompanionBuilder =
    MaintenanceRecordsCompanion Function({
      Value<int> id,
      required int vehicleId,
      Value<int?> itemSpecId,
      required String type,
      required DateTime date,
      required int odometer,
      Value<String?> place,
      Value<String?> memo,
      Value<int?> expenseId,
      Value<DateTime> createdAt,
    });
typedef $$MaintenanceRecordsTableUpdateCompanionBuilder =
    MaintenanceRecordsCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<int?> itemSpecId,
      Value<String> type,
      Value<DateTime> date,
      Value<int> odometer,
      Value<String?> place,
      Value<String?> memo,
      Value<int?> expenseId,
      Value<DateTime> createdAt,
    });

final class $$MaintenanceRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceRecordsTable,
          MaintenanceRecord
        > {
  $$MaintenanceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.maintenanceRecords.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ItemSpecsTable _itemSpecIdTable(_$AppDatabase db) =>
      db.itemSpecs.createAlias(
        $_aliasNameGenerator(db.maintenanceRecords.itemSpecId, db.itemSpecs.id),
      );

  $$ItemSpecsTableProcessedTableManager? get itemSpecId {
    final $_column = $_itemColumn<int>('item_spec_id');
    if ($_column == null) return null;
    final manager = $$ItemSpecsTableTableManager(
      $_db,
      $_db.itemSpecs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemSpecIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExpensesTable _expenseIdTable(_$AppDatabase db) =>
      db.expenses.createAlias(
        $_aliasNameGenerator(db.maintenanceRecords.expenseId, db.expenses.id),
      );

  $$ExpensesTableProcessedTableManager? get expenseId {
    final $_column = $_itemColumn<int>('expense_id');
    if ($_column == null) return null;
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_expenseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MaintenanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemSpecsTableFilterComposer get itemSpecId {
    final $$ItemSpecsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemSpecId,
      referencedTable: $db.itemSpecs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemSpecsTableFilterComposer(
            $db: $db,
            $table: $db.itemSpecs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpensesTableFilterComposer get expenseId {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemSpecsTableOrderingComposer get itemSpecId {
    final $$ItemSpecsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemSpecId,
      referencedTable: $db.itemSpecs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemSpecsTableOrderingComposer(
            $db: $db,
            $table: $db.itemSpecs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpensesTableOrderingComposer get expenseId {
    final $$ExpensesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableOrderingComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceRecordsTable> {
  $$MaintenanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ItemSpecsTableAnnotationComposer get itemSpecId {
    final $$ItemSpecsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemSpecId,
      referencedTable: $db.itemSpecs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemSpecsTableAnnotationComposer(
            $db: $db,
            $table: $db.itemSpecs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExpensesTableAnnotationComposer get expenseId {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.expenseId,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceRecordsTable,
          MaintenanceRecord,
          $$MaintenanceRecordsTableFilterComposer,
          $$MaintenanceRecordsTableOrderingComposer,
          $$MaintenanceRecordsTableAnnotationComposer,
          $$MaintenanceRecordsTableCreateCompanionBuilder,
          $$MaintenanceRecordsTableUpdateCompanionBuilder,
          (MaintenanceRecord, $$MaintenanceRecordsTableReferences),
          MaintenanceRecord,
          PrefetchHooks Function({
            bool vehicleId,
            bool itemSpecId,
            bool expenseId,
          })
        > {
  $$MaintenanceRecordsTableTableManager(
    _$AppDatabase db,
    $MaintenanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<int?> itemSpecId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> odometer = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int?> expenseId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MaintenanceRecordsCompanion(
                id: id,
                vehicleId: vehicleId,
                itemSpecId: itemSpecId,
                type: type,
                date: date,
                odometer: odometer,
                place: place,
                memo: memo,
                expenseId: expenseId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                Value<int?> itemSpecId = const Value.absent(),
                required String type,
                required DateTime date,
                required int odometer,
                Value<String?> place = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int?> expenseId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MaintenanceRecordsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                itemSpecId: itemSpecId,
                type: type,
                date: date,
                odometer: odometer,
                place: place,
                memo: memo,
                expenseId: expenseId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenanceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, itemSpecId = false, expenseId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable:
                                        $$MaintenanceRecordsTableReferences
                                            ._vehicleIdTable(db),
                                    referencedColumn:
                                        $$MaintenanceRecordsTableReferences
                                            ._vehicleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (itemSpecId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.itemSpecId,
                                    referencedTable:
                                        $$MaintenanceRecordsTableReferences
                                            ._itemSpecIdTable(db),
                                    referencedColumn:
                                        $$MaintenanceRecordsTableReferences
                                            ._itemSpecIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (expenseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.expenseId,
                                    referencedTable:
                                        $$MaintenanceRecordsTableReferences
                                            ._expenseIdTable(db),
                                    referencedColumn:
                                        $$MaintenanceRecordsTableReferences
                                            ._expenseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$MaintenanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceRecordsTable,
      MaintenanceRecord,
      $$MaintenanceRecordsTableFilterComposer,
      $$MaintenanceRecordsTableOrderingComposer,
      $$MaintenanceRecordsTableAnnotationComposer,
      $$MaintenanceRecordsTableCreateCompanionBuilder,
      $$MaintenanceRecordsTableUpdateCompanionBuilder,
      (MaintenanceRecord, $$MaintenanceRecordsTableReferences),
      MaintenanceRecord,
      PrefetchHooks Function({bool vehicleId, bool itemSpecId, bool expenseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$ItemSpecsTableTableManager get itemSpecs =>
      $$ItemSpecsTableTableManager(_db, _db.itemSpecs);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$MaintenanceRecordsTableTableManager get maintenanceRecords =>
      $$MaintenanceRecordsTableTableManager(_db, _db.maintenanceRecords);
}
