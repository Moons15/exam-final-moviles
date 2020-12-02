import 'dart:io';
import 'dart:async';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
part 'moor_database.g.dart';

@DataClassName("HeroDB")
class Heroes extends Table {
  TextColumn get hero => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {hero};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Heroes])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<HeroDB>> get watchAllHeroes => select(heroes).watch();

  Future<int> addHero(HeroDB hero) {
    return into(heroes).insert(hero);
  }

  Future<int> deleteHero(HeroDB hero) {
    return delete(heroes).delete(hero);
  }

  Future<List<HeroDB>> getHeroesByName(String name) {
    return (select(heroes)..where((tbl) => tbl.hero.like('%' + name + '%')))
        .get();
  }

  Stream<HeroDB> getHero(String name) {
    return (select(heroes)..where((tbl) => tbl.hero.equals(name)))
        .watchSingle();
  }
}
