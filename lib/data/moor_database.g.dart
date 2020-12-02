// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class HeroDB extends DataClass implements Insertable<HeroDB> {
  final String hero;
  final String name;
  HeroDB({@required this.hero, @required this.name});
  factory HeroDB.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return HeroDB(
      hero: stringType.mapFromDatabaseResponse(data['${effectivePrefix}hero']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || hero != null) {
      map['hero'] = Variable<String>(hero);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  HeroesCompanion toCompanion(bool nullToAbsent) {
    return HeroesCompanion(
      hero: hero == null && nullToAbsent ? const Value.absent() : Value(hero),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory HeroDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return HeroDB(
      hero: serializer.fromJson<String>(json['hero']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'hero': serializer.toJson<String>(hero),
      'name': serializer.toJson<String>(name),
    };
  }

  HeroDB copyWith({String hero, String name}) => HeroDB(
        hero: hero ?? this.hero,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('HeroDB(')
          ..write('hero: $hero, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(hero.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is HeroDB && other.hero == this.hero && other.name == this.name);
}

class HeroesCompanion extends UpdateCompanion<HeroDB> {
  final Value<String> hero;
  final Value<String> name;
  const HeroesCompanion({
    this.hero = const Value.absent(),
    this.name = const Value.absent(),
  });
  HeroesCompanion.insert({
    @required String hero,
    @required String name,
  })  : hero = Value(hero),
        name = Value(name);
  static Insertable<HeroDB> custom({
    Expression<String> hero,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (hero != null) 'hero': hero,
      if (name != null) 'name': name,
    });
  }

  HeroesCompanion copyWith({Value<String> hero, Value<String> name}) {
    return HeroesCompanion(
      hero: hero ?? this.hero,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (hero.present) {
      map['hero'] = Variable<String>(hero.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeroesCompanion(')
          ..write('hero: $hero, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $HeroesTable extends Heroes with TableInfo<$HeroesTable, HeroDB> {
  final GeneratedDatabase _db;
  final String _alias;
  $HeroesTable(this._db, [this._alias]);
  final VerificationMeta _heroMeta = const VerificationMeta('hero');
  GeneratedTextColumn _hero;
  @override
  GeneratedTextColumn get hero => _hero ??= _constructHero();
  GeneratedTextColumn _constructHero() {
    return GeneratedTextColumn(
      'hero',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [hero, name];
  @override
  $HeroesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'heroes';
  @override
  final String actualTableName = 'heroes';
  @override
  VerificationContext validateIntegrity(Insertable<HeroDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('hero')) {
      context.handle(
          _heroMeta, hero.isAcceptableOrUnknown(data['hero'], _heroMeta));
    } else if (isInserting) {
      context.missing(_heroMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {hero};
  @override
  HeroDB map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return HeroDB.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $HeroesTable createAlias(String alias) {
    return $HeroesTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $HeroesTable _heroes;
  $HeroesTable get heroes => _heroes ??= $HeroesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [heroes];
}
