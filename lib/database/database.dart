import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// Note: Foreign key is not enable by default in sqlite3. To enable it, use:
// beforeOpen: (details) async {
//   await customStatement('PRAGMA foreign_keys = ON');
// }
// USE THIS BEFORE OPENING THE DATABASE

class ParticipantsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventsId => integer().references(EventsTable, #id)();
  TextColumn get fullName => text()();
  TextColumn get email => text()();
  BoolColumn get attended => boolean().withDefault(const Constant(false))();
  TextColumn get organization => text().nullable()();
}

class EventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get participants => integer().withDefault(const Constant(0))();
  IntColumn get absentees => integer().withDefault(const Constant(0))();
}

class CertificatesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get participantsId =>
      integer().references(ParticipantsTable, #id)();
  TextColumn get filename => text()();
  BoolColumn get sended => boolean().withDefault(const Constant(false))();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [ParticipantsTable, EventsTable, CertificatesTable])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        return m.createAll();
      },
    );
  }

  Stream<List<EventsTableData>> getEvents() {
    return select(eventsTable).watch();
  }

  Future<void> addEvent(EventsTableCompanion event) {
    return into(eventsTable).insert(event);
  }
}
